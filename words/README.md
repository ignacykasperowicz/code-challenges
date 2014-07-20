Write a program which, given a dictionary, generates two
output files, 'sequences' and 'words'.  'sequences' should
contain every sequence of four letters that appears in exactly
one word of the dictionary, one sequence per line.  'words'
should contain the corresponding words that contain the
sequences, in the same order, again one per line.

For example, given the trivial dictionary containing only

```
arrows
carrots
give
me
```

The outputs should be:

```
'sequences'             'words'

carr                    carrots
give                    give
rots                    carrots
rows                    arrows
rrot                    carrots
rrow                    arrows
```

Of course, 'arro' does not appear in the output, since it is
found in more than one word.

For the final solution, read in the dictionary file in this repo.
