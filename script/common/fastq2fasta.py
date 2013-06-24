import sys
# usage: python fastq2fasta <fastq_file> <start> <numreads>

def main():
    file_name = sys.argv[1]
    if file_name == "stdin":
        file = sys.stdin
    else:
        file = open(file_name, "r")
    limited = True
    start = -1
    num = -1
    if len(sys.argv)<3:
        limited = False
    else:
        start = int(sys.argv[2])
        num = int(sys.argv[3])
    curr = 0
    printed = 0
    counted = 0
    sys.stderr.write("limited: %d, start: %d num: %d\n"%(limited, start, num))
    for line in file:
        #if counted==start and curr %4 ==0:
        #    sys.stderr.write("-> %s"%(line))
        if not limited or counted >= start:
                if curr % 4 == 0:
                    sys.stdout.write(">")
                    sys.stdout.write("%s"%(line[1:]))
                elif curr %4 == 1:
                    sys.stdout.write(line)
                    printed += 1
        if curr %4 == 3:
            counted += 1
        curr += 1
        if limited and printed>= num:
            break
    if file_name != "stdin":
        file.close()

if __name__ == "__main__":
    main()
