from Bio import SeqIO
import sys
import json
import datetime

# usage: python lcs_proc.py <datadir> <A.fasta> <B.fasta> <catalog.txt> <startindex> <batchsize>
def num_kind(s):
    na = 0
    nc = 0
    nt = 0
    ng = 0
    for c in s:
        if(c=='A'):
            na += 1
        if(c=='C'):
            nc += 1
        if(c=='T'):
            nt += 1
        if(c=='G'):
            ng += 1
    nzeros = 0
    if na == 0:
        nzeros += 1
    if nc == 0:
        nzeros += 1
    if nt == 0:
        nzeros += 1
    if ng == 0:
        nzeros += 1
    return(4-nzeros)

def longest_common_substring(s1, s2):
    candidates = []
    m = [[0] * (1 + len(s2)) for i in xrange(1 + len(s1))]
    longest, x_longest = 0, 0
    for x in xrange(1, 1 + len(s1)):
        for y in xrange(1, 1 + len(s2)):
            if s1[x - 1] == s2[y - 1]:
                m[x][y] = m[x - 1][y - 1] + 1
                if m[x][y] > 9:
                    candidates.append([m[x][y], x, s1[x-m[x][y]:x] ])
                if m[x][y] > longest:
                    longest = m[x][y]
                    x_longest = x
            else:
                m[x][y] = 0
    candidates = [ x for x in candidates if num_kind(x[2])>2]
    results = candidates
    n = len(candidates)
    if n>1:
        results = []
        results.append(candidates[-1])
        #        print "candidates: "
        #        print candidates
        for i in range(n-2, -1, -1):
        #            print "candidates[i][1]=%d, candidates[i+1][1]=%d"%(candidates[i][1], candidates[i+1][1])
            if candidates[i][1]+1!=candidates[i+1][1]:
            #                print "adding"
                results.append(candidates[i])
        results.reverse()
        #    print "returning:"
    #    print results
    return ([ s1[x_longest - longest: x_longest], results])


#print longest_common_substring("", "")

def read_bac(fname):
    result = dict([])
    arr = []
    for rec in SeqIO.parse(fname, "fasta"):
        seq = str(rec.seq)
        name = rec.description.split()[0]
        result[name] = seq
        arr.append(name)
    return([result, arr])


def read_catalog(fname):
    f = open(fname, 'r')
    result = set()
    index = 0
    for line in f:
        result.add(line.strip())
    f.close()
    return result

def main():
    dir = sys.argv[1]
    nei = sys.argv[2]
    chl = sys.argv[3]
    catalog = sys.argv[4]
    start_index = int(sys.argv[5])
    batch_size = int(sys.argv[6])

#    dir="/data/projects/current/sex_primers"
#    nei = "Neisseria_FA1090.fa"
#    chl = "Chlamydia_DUW-3CX.fa"

    (nei_dict, nei_names) = read_bac(dir+"/"+nei)
    (chl_dict, chl_names) = read_bac(dir+"/"+chl)
    to_skip = read_catalog(dir+"/"+catalog)
    contigs_to_proc = [n for n in nei_names if not n in to_skip]
    contigs_to_proc = contigs_to_proc[start_index:start_index+batch_size]

    for nei_seq in contigs_to_proc:
        sys.stderr.write("[%s] %s\n"%(datetime.datetime.now(), nei_seq))
        for chl_seq in chl_names:
            (lc, arr) =  longest_common_substring(nei_dict[nei_seq], chl_dict[chl_seq])
            if arr and len(lc)>9 and len(arr)>2 and arr[-1][1]-arr[0][1]> 20:
                print json.dumps([nei_seq, chl_seq, arr])

    sys.stderr.write("[%s]\n"%(datetime.datetime.now()))

if __name__ == "__main__":
    main()
