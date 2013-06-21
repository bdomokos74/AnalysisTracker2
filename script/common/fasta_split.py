import sys
from Bio import SeqIO

# usage: python fasta_split.py <fasta_file> <contig_index> <num_contigs>

def main():
    handle = open(sys.argv[1], 'rU')

    limited = True
    if len(sys.argv)<3:
        limited = False
    else:
        start = int(sys.argv[2])
        num = int(sys.argv[3])

    count = 0
    for rec in SeqIO.parse(handle, "fasta"):
        if count >= start:
            if limited and count >=start+num:
                break
            print ">%s"%(rec.id)
            print "%s"%(rec.seq)
        count += 1

    handle.close

if __name__ == "__main__":
    main()