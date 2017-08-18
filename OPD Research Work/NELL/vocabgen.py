import sys

i = 1
outfile = sys.argv[len(sys.argv)-1]
with open(outfile,"w") as outf:
	while i < (len(sys.argv) - 1): 
		infile = sys.argv[i]
		i += 1
		with open(infile, "r") as inf:
			x = 0
			for line in inf:
				words = line.split()
				while x < len(words):
					outf.writelines(words[x].strip() + "\n")
					x += 2