#include <stdio.h>
#include <stdlib.h>
int main(int argc, char **argv)
{
	if (argc != 2)
	{
		printf("usage: %s <value>\n", argv[0]);
		return 1;
	}
	int val = atoi(argv[1]);
	if (val >= 0 && val <= 15)
	{
		FILE *fout = fopen("/sys/devices/pci0000:00/"
				"0000:00:02.0/backlight/acpi_video0/brightness", "w");
		if (fout)
		{
			fprintf(fout, "%d\n", val);
			fclose(fout);
		}
	}
}

