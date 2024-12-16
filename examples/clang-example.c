/*
 * clang-example.c
 * Copyright (C) 2024 Martin J Levy - W6LHI/G8LHI - @mahtin - https://github.com/mahtin
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <regex.h>
#include <sys/types.h>

//
// This example assumes that you have run the Python code to create a regex string (which places the regex in the ~/.cache area)
//

static char *read_regex_file() {
    char filename[1024+1];
    FILE *fp;
    static char regex_line[1024+1];

    snprintf(filename, sizeof(filename)-1, "%s/%s", getenv("HOME"), ".cache/itu_appendix42/itu_appendix42.regex");

    fp = fopen(filename, "r");
    if (fp == 0) {
        fprintf(stderr, "%s: %d: %s\n", filename, errno, strerror(errno));
        exit(EXIT_FAILURE);
    }
    // only one line to read - make sure it's got the newline removed
    fgets(regex_line, sizeof(regex_line)-1, fp);
    regex_line[strlen(regex_line)-1] = '\0';
    return regex_line;
}

static int match_valid_suffix(char *suffix) {
    static const char *valid_suffix_list[] = {"/A", "/M", "/MM", "/P", "/QRP", "/QRPP"};

    for (int ii=0; ii<(sizeof(valid_suffix_list)/sizeof(char *)); ii++) {
        if (strcmp(suffix, valid_suffix_list[ii]) == 0) {
            return 1;
        }
    }
    return 0;
}

#define N_RM 3

static void doit(regex_t *re, FILE *fp) {
    char line[1024+1];

    while ((fgets(line, sizeof(line)-1, fp)) != NULL) {
        regmatch_t rm[N_RM];

        line[strlen(line)-1] = '\0'; // remove newline

        // do we match - bail out quickly if we don't
        if (regexec(re, line, N_RM, rm, 0) != 0) {
            printf("%-10s INVALID\n", line);
            continue;
        }

        // printf("%-10s\t", line);
        // for (int ii=0;ii<N_RM;ii++) {
        //     if (rm[ii].rm_eo == -1 && rm[ii].rm_so == -1)
        //         break;
        //     printf("%lld len(%d)\t", rm[ii].rm_so, (int)(rm[ii].rm_eo - rm[ii].rm_so));
        // }

        // The entire regular expression's match addresses are stored in pmatch[0].

        if (rm[0].rm_so == 0 && strlen(line) == (int)rm[0].rm_eo) {
            printf("%s\n", line);
            continue;
        }

        if (rm[0].rm_so > 0 && line[rm[0].rm_so - 1] == '/' && strlen(line + rm[0].rm_so) == (int)(rm[0].rm_eo - rm[0].rm_so)) {
            printf("%s -> %.*s EXACT WITH PREFIX (%d,%d) (%d,%d) (%d,%d)\n", line, (int)(rm[0].rm_eo - rm[0].rm_so), line + rm[0].rm_so,
                (int)rm[0].rm_so, (int)rm[0].rm_eo,
                (int)rm[1].rm_so, (int)rm[1].rm_eo,
                (int)rm[2].rm_so, (int)rm[2].rm_eo
            );
            continue;
        }

        if (rm[0].rm_so == 0 && line[rm[0].rm_eo] == '/') {
            if (match_valid_suffix(&line[rm[0].rm_eo])) {
                printf("%s -> %.*s\n", line, (int)(rm[0].rm_eo - rm[0].rm_so), line + rm[0].rm_so);
                continue;
            }
            printf("%s -> %.*s EXACT WITH SUFFIX\n", line, (int)(rm[0].rm_eo - rm[0].rm_so), line + rm[0].rm_so);
            continue;
        }

        if (rm[0].rm_so != 0) {
            // does not start at position 0
            printf("%-10s -> %.*s INVALID2\n", line, (int)(rm[0].rm_eo - rm[0].rm_so), line + rm[0].rm_so);
            continue;
        }

        printf("%s -> %.*s\n", line, (int)(rm[0].rm_eo - rm[0].rm_so), line + rm[0].rm_so);
    }
}

int main(int argc, char **argv) {
    char *callsign_regex;
    FILE *fp;
    regex_t re;

    callsign_regex = read_regex_file();

    if (regcomp(&re, callsign_regex, REG_EXTENDED) != 0) {
        fprintf(stderr, "Failed to compile callsign regex '%s'\n", callsign_regex);
        return EXIT_FAILURE;
    }

    if (argc > 1) {
        char *filename = argv[1];
        fp = fopen(filename, "r");
        if (fp == 0) {
            fprintf(stderr, "%s: %d: %s)\n", filename, errno, strerror(errno));
            return EXIT_FAILURE;
        }
    } else {
        fp = stdin;
    }

    doit(&re, fp);
    return EXIT_SUCCESS;
}
