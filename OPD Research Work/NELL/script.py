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
				if words[x] == "r":
					x += 1
					while x < len(words):
						outf.writelines(str(float(words[x+2].strip())/100) + "::" + infile + "(" + words[x].replace("\"","").strip() + words[x+1].replace("\"","").strip() + ").\n")
						x += 3
				else:
					while x < len(words):
						outf.writelines(str(float(words[x+1].strip())/100) + "::" + infile + "(" + words[x].strip() + ").\n")
						x += 2