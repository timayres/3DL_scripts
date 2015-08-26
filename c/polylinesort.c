#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRUE  1
#define FALSE 0

#define OUT_NAME "polyline%d.xyz"

struct line_set {
  int p1;
  int p2;
  };

struct vertices_set {
  float x;
  float y;
  float z;
  };

int write_output(int, int, int *, struct vertices_set *);
void pause();

int main (int argc, char *argv[])
  {
  int i, j;
  FILE *fpi;               // input file pointer
  char input_line[80];
  char temp_char[10];
  int temp_point;
  int num_vertices = 0;
  int num_line_sets = 0;
  int num_polylines = 0;
  int next_point, start_point;
  int sort_cnt = 0;
  int line_cnt = 0;
  int loop_cnt = 0;
  struct line_set *lines;
  struct vertices_set *vertices;
  int *sorted_points;
  fpos_t position, vertices_position, line_set_position;
  int first_vertices = FALSE;
  int first_line_set = FALSE;
  int polyline_started = FALSE;
  int tail_found = FALSE;

  // make sure there's an input filename passed
  if (argc < 2)
    {
    printf("Input filename argument is missing \n");
    exit(1);
    }

  // open input file
  printf("Opening input file %s \n",argv[1]);
  fpi = fopen(argv[1],"r");
  if (fpi == NULL)
    {
    printf("Error opening file \n");
    exit(1);
    }

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
      num_line_sets++;
      }
    }

  printf("vertices %d line sets %d\n",num_vertices, num_line_sets);

  // need at least 2 vertices and 1 line set in the input file
  if (num_vertices < 2 || num_line_sets == 0)
    {
    printf("Error: number of vertices < 2 or number line sets = 0\n");
    fclose(fpi);
    exit(1);
    }

  lines = (struct line_set *)malloc(num_line_sets * sizeof(struct line_set));
  if (lines == NULL)
    {
    fclose(fpi);
    exit(1);
    }

  vertices = (struct vertices_set *)malloc(num_vertices * sizeof(struct vertices_set));
  if (vertices == NULL)
    {
    free(lines);
    fclose(fpi);
    exit(1);
    }

  sorted_points = (int *)malloc(num_line_sets * sizeof(int));
  if (sorted_points == NULL)
    {
    free(lines);
    free(vertices);
    fclose(fpi);
    exit(1);
    }

  // set file position to first vectices line
  fsetpos(fpi, &vertices_position);

  // read the vertices set
  printf("Reading vertices\n");
  for (i = 0; i < num_vertices;)
    {
    fgets(input_line, sizeof(input_line), fpi);
    if (strncmp(input_line, "v ", 2) != 0)
      continue;

    sscanf(input_line, "%s %f %f %f", temp_char, (float *)&(vertices[i].x),
                                                 (float *)&(vertices[i].y),
                                                 (float *)&(vertices[i].z));
    i++;
    }

  // set file position to first line set
  fsetpos(fpi, &line_set_position);

  // read the lines sets
  printf("Reading line sets\n");
  for (i = 0; i < num_line_sets;)
    {
    fgets(input_line, sizeof(input_line), fpi);
    if (strncmp(input_line, "l ", 2) != 0)
      continue;

    sscanf(input_line, "%s %d %d", temp_char, (int *)&(lines[i].p1),
                                              (int *)&(lines[i].p2));
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
  while (line_cnt < num_line_sets)
    {
    loop_cnt = 0;

    // process next line set
    for (i = 0; i < num_line_sets; i++)
      {
      // skip line set points if already used
      if (lines[i].p1 == 0)
       continue;

      // start new polyline
      if (!polyline_started)
        {
        polyline_started = TRUE;
        tail_found = FALSE;
        num_polylines++;

        // save the first 2 line points
        sorted_points[0] = lines[i].p1;
        sorted_points[1] = lines[i].p2;
        sort_cnt = 2;

        // save the starting point and set the next point to find
        start_point = lines[i].p1;
        next_point = lines[i].p2;

        // set points in the line set to 0 to eliminate them from remaining line sets
        lines[i].p1 = 0;
        lines[i].p2 = 0;
        line_cnt++;
        break;
        }

      // found next point and other point is not start point
      if ((lines[i].p1 == next_point && lines[i].p2 != start_point) ||
          (lines[i].p2 == next_point && lines[i].p1 != start_point))
        {
        if (lines[i].p1 == next_point)
          {
          sorted_points[sort_cnt] = lines[i].p2;
          sort_cnt++;
          next_point = lines[i].p2;
          }
        else
          {
          sorted_points[sort_cnt] = lines[i].p1;
          sort_cnt++;
          next_point = lines[i].p1;
          }
        lines[i].p1 = 0;
        lines[i].p2 = 0;
        line_cnt++;
        break;
        }

      // found next point and other point is start point, closed polyline
      if ((lines[i].p1 == next_point && lines[i].p2 == start_point) ||
          (lines[i].p2 == next_point && lines[i].p1 == start_point))
        {
        printf("Polyline %d is a closed polyline set of %d points \n", num_polylines, sort_cnt);

        // print the sorted line sets
        for (j = 1; j < sort_cnt; j++)
          printf("%d %d \n", sorted_points[j-1], sorted_points[j]);
        printf("%d %d \n", sorted_points[sort_cnt-1], sorted_points[0]);

        write_output(num_polylines, sort_cnt, sorted_points, vertices);
        polyline_started = FALSE;
        lines[i].p1 = 0;
        lines[i].p2 = 0;
        line_cnt++;
        break;
        }

      // next point was not found in remaining line sets
      if (i + 1 == num_line_sets)
        loop_cnt = 1;
      }  // end for loop

    // if polyline started and next point not found
    if (polyline_started && loop_cnt == 1)
      {
      // if tail already found we're at the head of the polyline
      if (tail_found)
        {
        printf("Polyline %d is an open polyline set of %d points\n", num_polylines, sort_cnt);

        // print the sorted line sets
        for (j = 1; j < sort_cnt; j++)
          printf("%d %d \n", sorted_points[j-1], sorted_points[j]);

        write_output(num_polylines, sort_cnt, sorted_points, vertices);
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
  if (polyline_started)
    {
    printf("Polyline %d is an open polyline set of %d points\n", num_polylines, sort_cnt);

    // print the sorted line sets
    for (j = 1; j < sort_cnt; j++)
      printf("%d %d \n", sorted_points[j-1], sorted_points[j]);

    write_output(num_polylines, sort_cnt, sorted_points, vertices);
    }

  printf("End of line sets \n");
  free(lines);
  free(vertices);
  free(sorted_points);
//  pause();
  return 0;
  }

/************************************************************************************/
int write_output(int num_polylines, int sort_cnt, int *sorted_points,
                 struct vertices_set *vertices)
  {
  int i, temp_point;
  FILE *fpo;               // output file pointer
  char outfile[256];

  // open output file
  sprintf(outfile, OUT_NAME, num_polylines);
  printf("Opening output file %s \n",outfile);
  fpo = fopen(outfile,"w");
  if (fpo == NULL)
    {
    printf("Error opening output file %s \n", outfile);
    return 1;
    }

  // write the xyz vertices for each sorted point
  printf("Writing sorted point vertices xyz values \n");
  for (i = 0; i < sort_cnt; i++)
    {
    temp_point = sorted_points[i] - 1;
    fprintf(fpo,"%f %f %f \n", vertices[temp_point].x,
                               vertices[temp_point].y,
                               vertices[temp_point].z);

    printf("%f %f %f \n", vertices[temp_point].x,
                          vertices[temp_point].y,
                          vertices[temp_point].z);
    }

  fclose(fpo);
  return 0;
  }

/************************************************************************************/
void pause()
  {
  printf("\nHit any key to continue... \n");
  getchar();
  }
