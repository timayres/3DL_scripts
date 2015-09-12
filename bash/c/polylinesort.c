/****************************************************************
*
*  polylinesort.c
*  License: LGPLv2.1
*
*****************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

//
// boolean variables
//
#define TRUE  1
#define FALSE 0

int polyline_started = FALSE;
int tail_found = FALSE;
int closed_polyline =FALSE;

// integer variables
int num_vertices = 0;
int num_linesets = 0;
int num_polylines = 0;
int next_point;
int start_point;
int sort_cnt = 0;
int line_cnt = 0;
int loop_cnt = 0;

//
// array variables
//
//  V[] - vertice "v" points x, y, and z
//  L[] - line set "l" points p1 and p2
//  sorted_points[] - sorted polyline points
//  polyline_lengths - total length of each polyline
//
struct line_set {
  int p1;
  int p2;
  };

struct vertices_set {
  float x;
  float y;
  float z;
  };

struct vertices_set *V;
struct line_set *L;
int *sorted_points;
double polyline_lengths[256];

void write_polyline();
void write_lengths();

/****************************************************************
*
*              Start of Main Program
*
*****************************************************************/
int main (int argc, char *argv[])
  {
  int i, j;
  FILE *fpi;               // input file pointer
  char input_line[80];
  char temp_char[10];
  int temp_point;
  fpos_t position, vertices_position, line_set_position;
  int first_vertices = FALSE;
  int first_line_set = FALSE;

  // make sure there's an input filename passed
  if (argc < 2)
    {
    printf("Input filename argument is missing \n");
    exit(1);
    }

  // open input file
  fpi = fopen(argv[1],"r");
  if (fpi == NULL)
    {
    printf("Error opening input file %s \n",argv[1]);
    exit(1);
    }

  printf("Reading vertices and line sets from input file %s\n",argv[1]);

  // first count the vertices and lines sets
  while (1)
    {
    // always save current file position prior to reading next line
    fgetpos(fpi, &position);

    if (fgets(input_line, sizeof(input_line), fpi) == NULL)
      break;

    // ignore any lines that don't start with "l " or "v "
    if (strncmp(input_line, "v ",2) != 0 && strncmp(input_line,"l ",2) != 0)
      continue;

    if (input_line[0] == 'v')
      {
      // if first vertices line,then save the current file position
      if (!first_vertices)
        {
        first_vertices = TRUE;
        vertices_position = position;
        }
      num_vertices++;
      }

    if (input_line[0] == 'l')
      {
      // if first line set then save the current file position
      if (!first_line_set)
        {
        first_line_set = TRUE;
        line_set_position = position;
        }
      num_linesets++;
      }
    }

  printf("vertices %d line sets %d\n",num_vertices, num_linesets);

  // need at least 2 vertices and 1 line set in the input file
  if (num_vertices < 2 || num_linesets == 0)
    {
    printf("Error: number of vertices < 2 or number line sets = 0\n");
    fclose(fpi);
    exit(1);
    }

  L = (struct line_set *)malloc(num_linesets * sizeof(struct line_set));
  if (L == NULL)
    {
    fclose(fpi);
    exit(1);
    }

  V = (struct vertices_set *)malloc(num_vertices * sizeof(struct vertices_set));
  if (V == NULL)
    {
    free(L);
    fclose(fpi);
    exit(1);
    }

  sorted_points = (int *)malloc(num_linesets * sizeof(int));
  if (sorted_points == NULL)
    {
    free(L);
    free(V);
    fclose(fpi);
    exit(1);
    }

  // set file position to first vectices line
  fsetpos(fpi, &vertices_position);

  // read the vertices set
  for (i = 0; i < num_vertices;)
    {
    fgets(input_line, sizeof(input_line), fpi);
    if (strncmp(input_line, "v ", 2) != 0)
      continue;

    sscanf(input_line, "%s %f %f %f", temp_char, (float *)&(V[i].x),
                                                 (float *)&(V[i].y),
                                                 (float *)&(V[i].z));
    i++;
    }

  // set file position to first line set
  fsetpos(fpi, &line_set_position);

  // read the lines sets
  for (i = 0; i < num_linesets;)
    {
    fgets(input_line, sizeof(input_line), fpi);
    if (strncmp(input_line, "l ", 2) != 0)
      continue;

    sscanf(input_line, "%s %d %d", temp_char, (int *)&(L[i].p1),
                                              (int *)&(L[i].p2));
    i++;
    }

  // close the input file
  fclose(fpi);

  printf("Sorting line set points \n");

/*********************************************************************************************
  Process each input line set 1 to n until all the points in the line set are sorted
  into 1 or more polyline sets of continuous points. The polyline sets can be either
  and open polyline or a closed polyine defining a polygon.

  These are the possible cases for the current input line set of points being processed and
  any previous line set points that were already processed:

  1. If line set p1 is zero these points in have already been processed so skip line.

  2. If a polyline has not been started then p1 is set to the start point of the new polyline.
     The second point p2 is the next point in the polyline and is also the next point
     to look for in the remaining line set points.

  3. Either p1 or p2 is the next point and the other point is not the start point.
     Save the other point and set it to the next point to find.

  4. Either p1 or p2 is the next point and the other point is the start point.
     This indicates that the polyline is closed (polygon).

     Note: If any line sets are remaining then continue processing them as
           a new polyline.

  5. The next point was not found in the remaining line set points so it's an open polyline.
     If the tail has already been found then the last sorted point is the head and
     the polyline is finished. Otherwise the last sorted point is the tail and the next
     point to find is the saved start point towards the head of the polyline.

**************************************************************************/

  // loop until all the points in line sets have been sorted
  while (line_cnt < num_linesets)
    {
    loop_cnt = 0;

    // process next line set
    for (i = 0; i < num_linesets; i++)
      {
      // skip line set points if already used
      if (L[i].p1 == 0)
       continue;

      // start new polyline
      if (!polyline_started)
        {
        polyline_started = TRUE;
        tail_found = FALSE;
        num_polylines++;

        // save the first 2 line points
        sorted_points[0] = L[i].p1;
        sorted_points[1] = L[i].p2;
        sort_cnt = 2;

        // save the starting point and set the next point to find
        start_point = L[i].p1;
        next_point = L[i].p2;

        // set points in the line set to 0 to eliminate them from remaining line sets
        L[i].p1 = 0;
        L[i].p2 = 0;
        line_cnt++;
        break;
        }

      // found next point and other point is not start point
      if ((L[i].p1 == next_point && L[i].p2 != start_point) ||
          (L[i].p2 == next_point && L[i].p1 != start_point))
        {
        if (L[i].p1 == next_point)
          {
          sorted_points[sort_cnt] = L[i].p2;
          sort_cnt++;
          next_point = L[i].p2;
          }
        else
          {
          sorted_points[sort_cnt] = L[i].p1;
          sort_cnt++;
          next_point = L[i].p1;
          }
        L[i].p1 = 0;
        L[i].p2 = 0;
        line_cnt++;
        break;
        }

      // found next point and other point is start point, closed polyline
      // write the polyline output
      if ((L[i].p1 == next_point && L[i].p2 == start_point) ||
          (L[i].p2 == next_point && L[i].p1 == start_point))
        {
        closed_polyline=TRUE;
        write_polyline();
        polyline_started = FALSE;
        L[i].p1 = 0;
        L[i].p2 = 0;
        line_cnt++;
        break;
        }

      // next point was not found in remaining line sets
      if (i + 1 == num_linesets)
        loop_cnt = 1;
      }  // end for loop

    // if polyline started and next point not found
    if (polyline_started && loop_cnt == 1)
      {
      // if tail already found we're at the head of the polyline
      // write the polyline output
      if (tail_found)
        {
        closed_polyline=FALSE;
        write_polyline();
        polyline_started = FALSE;
        continue;
        }
      else
        {
        // tail of an open polyline, set next point to look for head in remaining line sets
        tail_found = TRUE;
        next_point = start_point;
        start_point = sorted_points[sort_cnt - 1];

        // reorder the sorted points so tail is the first point
        for (i = 0, j = sort_cnt - 1; j > i; i++, j--)
          {
          temp_point = sorted_points[i];
          sorted_points[i] = sorted_points[j];
          sorted_points[j] = temp_point;
          }
        continue;
        }
      }
    } // end while loop

  // if a polyline was started and end of line sets
  // write the polyline output
  if (polyline_started)
    {
    closed_polyline=FALSE;
    write_polyline();
    }

  printf("End of line sets \n");

  // write the polyline lengths
  write_lengths();
  free(L);
  free(V);
  free(sorted_points);
  return 0;
  }

/************************************/
/* write polyline output function   */
/************************************/
void write_polyline()
  {
  // output file name
  char filename[] = "polyline%d.xyz";
  int j,k;
  int temp_point;
  int p1,p2;
  double line_length;
  double total_length=0;
  FILE *fpo;               // output file pointer
  char outfile[256];

  if (closed_polyline)
    printf("Polyline %d is a closed polyline set of %d points \n", num_polylines - 1, sort_cnt);
  else
    printf("Polyline %d is an open polyline set of %d points \n", num_polylines - 1, sort_cnt);

  // print the sorted line sets and line lengths
  for (j = 1, k = 0; j < sort_cnt; j++, k++)
    {
    p1 = sorted_points[k] - 1;
    p2 = sorted_points[j] - 1;
    line_length = sqrt(pow(V[p2].x - V[p1].x, 2) +
                       pow(V[p2].y - V[p1].y, 2) +
                       pow(V[p2].z - V[p1].z, 2));
    total_length += line_length;

    printf("%d %d length %f \n", sorted_points[k], sorted_points[j], line_length);
    }
  if (closed_polyline)
    {
    p1 = sorted_points[k] - 1;
    p2 = sorted_points[0] - 1;
    line_length = sqrt(pow(V[p2].x - V[p1].x, 2) +
                       pow(V[p2].y - V[p1].y, 2) +
                       pow(V[p2].z - V[p1].z, 2));
    total_length += line_length;

    printf("%d %d length %f \n", sorted_points[k], sorted_points[0], line_length);
    }

  // save the polyline length
  polyline_lengths[num_polylines - 1] = total_length;
  printf("Total polyline length %f \n", total_length);

  // open polyline output file
  sprintf(outfile, filename, num_polylines - 1);
  remove(outfile);
  fpo = fopen(outfile,"w");
  if (fpo == NULL)
    {
    printf("Error opening output file %s \n", outfile);
    return;
    }

  // write the xyz vertices for each sorted point
  printf("Writing sorted vertice points xyz to %s \n", outfile);
  for (j = 0; j < sort_cnt; j++)
    {
    temp_point = sorted_points[j] - 1;
    printf("%f %f %f \n", V[temp_point].x, V[temp_point].y, V[temp_point].z);
    fprintf(fpo,"%f %f %f \n", V[temp_point].x, V[temp_point].y, V[temp_point].z);
    }
  if (closed_polyline)
    {
    temp_point = sorted_points[0] - 1;
    printf("%f %f %f \n", V[temp_point].x, V[temp_point].y, V[temp_point].z);
    fprintf(fpo,"%f %f %f \n", V[temp_point].x, V[temp_point].y, V[temp_point].z);
    }

  fclose(fpo);
  }

/************************************/
/* write polyline lengths function  */
/************************************/
void write_lengths()
  {
  char filename[] = "polyline_lengths.txt";
  FILE *fp;
  int i;

  // open polyline lengths output file
  remove(filename);
  fp = fopen(filename,"w");
  if (fp == NULL)
    {
    printf("Error opening output file %s \n", filename);
    return;
    }

  printf("Writing polyline lengths to %s \n", filename);

  for (i = 0; i < num_polylines; i++)
    {
    printf("%f ", polyline_lengths[i]);
    fprintf(fp,"%f ", polyline_lengths[i]);
    }

  printf("\n");
  fprintf(fp,"\n");
  fclose(fp);
  }

