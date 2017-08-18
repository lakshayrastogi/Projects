import sys

i = 2
vocab = sys.argv[1]
outfile = sys.argv[len(sys.argv)-1]
with open(outfile,"w") as outf:
	with open(vocab, "r") as voc:
		vocabWords = []
		for vline in voc:
			temp = vline.split()
			vocabWords.append(temp[0])
		while i < (len(sys.argv) - 1): 
			infile = sys.argv[i]
			i += 1
			with open(infile, "r") as inf:
				x = 0
				k = 0
				for line in inf:
					words = line.split()
					if words[x] == "r":
						x += 1
						while k < len(vocabWords):
							j = 0
							while j < len(vocabWords):
								if j != k:
									added = 0
									while x < len(words):
										if vocabWords[k] + "," + vocabWords[j] == words[x].replace("\"","").strip() + words[x+1].replace("\"","").strip():
											outf.writelines(str(float(words[x+2].strip())/100) + "::" + infile + "(" + words[x].replace("\"","").strip() + words[x+1].replace("\"","").strip() + ").\n")
											added = 1
											x = 1
											break
										x += 3
									x = 1
									if added == 0:
										outf.writelines("0.01" + "::" + infile + "(" + vocabWords[k] + "," + vocabWords[j] + ").\n")
								j += 1
							k += 1
					else:
						while k < len(vocabWords):
							added = 0
							while x < len(words):
								if vocabWords[k] == words[x].strip():
									outf.writelines(str(float(words[x+1].strip())/100) + "::" + infile + "(" + words[x].strip() + ").\n")
									added = 1
									x = 0
									break
								x += 2
							x = 0
							if added == 0:
								outf.writelines("0.01" + "::" + infile + "(" + vocabWords[k] + ").\n")
							k += 1