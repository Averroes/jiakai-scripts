/*
 * $File: oi-main.cpp
 * $Date: Wed Jul 20 18:09:26 2011 +0800
 * $Author: jiakai <jia.kai66@gmail.com>
 */

// f{{{ 

#include <stdint.h>
#include <algorithm>
#include <bitset>
#include <cmath>
#include <cassert>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <deque>
#include <functional>
#include <iomanip>
#include <iostream>
#include <list>
#include <map>
#include <numeric>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <utility>
#include <vector>
#include <limits>

#define ITER_VECTOR(v, var) \
	for (typeof((v).begin()) var = (v).begin(); var != (v).end(); var ++)

#define ITER_VECTOR_IDX(v, var) \
	for (typeof((v).size()) var = 0; var < (v).size(); var ++)

using namespace std;

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
// vim: filetype=cpp foldmethod=marker foldmarker=f{{{,f}}}
EXE_BEGIN_TEMPLATE
set filetype=cpp
set foldmethod=marker
set foldmarker=f{{{,f}}}
normal 45G
EXE_END_TEMPLATE
