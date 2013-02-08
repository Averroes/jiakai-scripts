/*
 * $File: datastructure.cpp
 * $Date: Tue Oct 09 23:41:14 2012 +0800
 * $Author: jiakai <jia.kai66@gmail.com>
 */

// f{{{  preamble

#include <cstdio>

#define ITER_VECTOR(v, var) \
	for (typeof((v).begin()) var = (v).begin(); var != (v).end(); var ++)

#define ITER_VECTOR_IDX(v, var) \
	for (typeof((v).size()) var = 0; var < (v).size(); var ++)

#define DECLARE_STATIC(var) \
	__typeof__(var) var

// f}}}

namespace Solve
{
}

// f{{{ main
int main()
{
#if defined(INPUT) && defined(OUTPUT) && !defined(STDIO) && !defined(ONLINE_JUDGE)
	FILE *fin = fopen(INPUT, "r"),
		 *fout = fopen(OUTPUT, "w");
	Solve::solve(fin, fout);
	fclose(fin);
	fclose(fout);
#else
	Solve::solve(stdin, stdout);
#endif
}
// f}}}
// vim: filetype=cpp syntax=cpp.doxygen foldmethod=marker foldmarker=f{{{,f}}}

