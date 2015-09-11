/****************************************************************
*
*  AABB.c - Axis Aligned Bounding Box
*  License: LGPLv2.1
*
*****************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

struct vertices_set {
  float x;
  float y;
  float z;
  };
struct vertices_set *V;

int num_vertices;
float minX;
float maxX;
float minY;
float maxY;
float minZ;
float maxZ;
float centerX;
float centerY;
float centerZ;
float sizeX;
float sizeY;
float sizeZ;
double diag;

char filename[]="AABB.txt";

int main (int argc, char *argv[])
  {
  int i;
  FILE *fp;
  char input_line[80];

  // make sure there's an input filename passed
  if (argc < 2)
    {
    printf("Input filename argument is missing \n");
    exit(1);
    }

  // open input file
  fp = fopen(argv[1],"r");
  if (fp == NULL)
    {
    printf("Error opening input file %s \n",argv[1]);
    exit(1);
    }

  // first count the vertice lines
  while (fgets(input_line, sizeof(input_line), fp) != NULL)
    num_vertices++;

  printf("Reading %d vertices from input file %s\n",num_vertices,argv[1]);

  V = (struct vertices_set *)malloc(num_vertices * sizeof(struct vertices_set));
  if (V == NULL)
    {
    fclose(fp);
    exit(1);
    }

  // read the vertices and calculate min/max values
  rewind(fp);
  for (i = 0; i < num_vertices; i++)
    {
    fgets(input_line, sizeof(input_line), fp);
    sscanf(input_line, "%f %f %f", (float *)&(V[i].x), (float *)&(V[i].y), (float *)&(V[i].z));
    printf("%f %f %f \n", V[i].x, V[i].y, V[i].z);
    if (i == 0)
      {
      minX = maxX = V[0].x;
      minY = maxY = V[0].y;
      minZ = maxZ = V[0].z;
      continue;
      }

     if (V[i].x < minX) minX = V[i].x;
     if (V[i].x > maxX) maxX = V[i].x;
     if (V[i].y < minY) minY = V[i].y;
     if (V[i].y > maxY) maxY = V[i].y;
     if (V[i].z < minZ) minZ = V[i].z;
     if (V[i].z > maxZ) maxZ = V[i].z;
    }

  // close the input file
  fclose(fp);

  // calculate remaining values
  centerX = (maxX + minX) / 2;
  centerY = (maxY + minY) / 2;
  centerZ = (maxZ + minZ) / 2;
  sizeX = maxX- minX;
  sizeY = maxY- minY;
  sizeZ = maxZ- minZ;
  diag=sqrt(pow(sizeX,2) + pow(sizeY,2) + pow(sizeZ,2));

  printf("minX %f \n", minX);
  printf("maxX %f \n", maxX);
  printf("minY %f \n", minY);
  printf("maxY %f \n", maxY);
  printf("minZ %f \n", minZ);
  printf("maxZ %f \n", maxZ);
  printf("centerX %f \n", centerX);
  printf("centerY %f \n", centerY);
  printf("centerZ %f \n", centerZ);
  printf("sizeX %f \n", sizeX);
  printf("sizeY %f \n", sizeY);
  printf("sizeZ %f \n", sizeZ);
  printf("diag %f \n", diag);

  printf("Writing values to %s \n", filename);

  // open output file
  remove(filename);
  fp = fopen(filename,"w");
  if (fp == NULL)
    {
    printf("Error opening output file %s \n",filename);
    return 1;
    }

  fprintf(fp,"minX %f \n", minX);
  fprintf(fp,"maxX %f \n", maxX);
  fprintf(fp,"minY %f \n", minY);
  fprintf(fp,"maxY %f \n", maxY);
  fprintf(fp,"minZ %f \n", minZ);
  fprintf(fp,"maxZ %f \n", maxZ);
  fprintf(fp,"centerX %f \n", centerX);
  fprintf(fp,"centerY %f \n", centerY);
  fprintf(fp,"centerZ %f \n", centerZ);
  fprintf(fp,"sizeX %f \n", sizeX);
  fprintf(fp,"sizeY %f \n", sizeY);
  fprintf(fp,"sizeZ %f \n", sizeZ);
  fprintf(fp,"diag %f \n", diag);

  fclose(fp);
  free(V);
  return 0;
  }

