#include <stdio.h>

int file_size(const char* file)
{
	FILE* fp;
	int ret;

	fp = fopen(file, "r");
	if(!fp)
		return -1;

	fseek(fp, 0, SEEK_END);
	ret = ftell(fp);
	fclose(fp);

	return ret;
}

int main(int argc, char* argv[])
{
	char Buffer[1024];
	FILE* fp, *fil;
	int i, bytesRead;
	int fileSize;
	int totalWritten = 0;
	int farg_start = 1;
        int paddEnd = 0;
        char whatToPad = 0;
        char* outfile;
        
        
	if(argc < 4)
	{
		printf("This program requires at least 3 file-parameters\n\nsyntax:\ncopy2gether output input1 input2 [inputn]\n");
		return -1;
	}
        
        if(argv[1][0] == '-')
        {
        	if(strcmp(argv[1], "-paddend") == 0)
                {
                	paddEnd = atoi(argv[2]);
                	whatToPad = atoi(argv[3]);
                        farg_start = 4;
                        
                        printf("padding output-file to a total size of %d with %d\n", paddEnd, whatToPad);
                }
        }

        outfile = argv[farg_start];
	fp = fopen(argv[farg_start], "w+");
        printf("Output file is %s\n", argv[farg_start]);

	for(i = farg_start+1; i < argc; i++)
	{
		fileSize = file_size(argv[i]);
                printf("%s has %d bytes\n", argv[i], fileSize);
		fil = fopen(argv[i], "r");
                totalWritten += fileSize;
		while(fileSize > 0)
		{
			fread(Buffer, sizeof(Buffer), 1, fil);
			bytesRead = (fileSize > sizeof(Buffer)) ? sizeof(Buffer) : fileSize;
			fwrite(Buffer, bytesRead, 1, fp);
			fileSize -= sizeof(Buffer);
		}
		fclose(fil);
	}
        if(paddEnd != 0)
        {
        	int i;
        	for(i = 0; i < (paddEnd-totalWritten); i++)
                	fwrite(&whatToPad, 1, 1, fp);
                        
                totalWritten = paddEnd;
        }
        
	printf("%d bytes written into %s\n", totalWritten, outfile);
	fclose(fp);
	return 0;
}
