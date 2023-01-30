import sys
import csv
import argparse

def parse_args(args=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("FILE_IN", help="Input FASTA file.")
    parser.add_argument("FILE_OUT", help="Output TSV file.")
    parser.add_argument(
        "-r",
        "--regions",
        dest="REGIONS",
        type=str,
        help="Regions to count (collapsed bed format).",
    )
    return parser.parse_args(args)


def count_Ns_in_region(input, output, regions):
    

    # Initialize an empty dictionary to store the FASTA records
    FASTAs = {}

    # Read the FASTA file from the standard input stream
    with open(input) as f:
        for line in f:
            # If the line starts with a ">" character, it is the header line
            # for a new FASTA record
            if line.startswith(">"):
                # Extract the name of the FASTA record from the header line
                name = line.strip()[1:]
                # Initialize a new entry in the dictionary for the FASTA record
                FASTAs[name] = ""
            else:
                # Add the sequence line to the FASTA record
                FASTAs[name] += line.strip()


    with open(regions) as f:
        lines = [l.split('\t') for l in f.readlines()]
        regions = [{'name':line[3], 'start':int(line[1]), 'stop':int(line[2])} for line in lines]

    # for heatmap
    with open(output, 'w') as f:
        cols = '\t'.join(['chrom', 'start','end', 'region', 'coverage', 'sample'])
        f.write(f"{cols}\n")
        for fasta in FASTAs:
            for region in regions:
                amplicon = FASTAs[fasta][region['start']: region['stop']]
                percent_Ns = ((amplicon.lower().count('n') + amplicon.lower().count('-'))/len(amplicon))*100
                f.write(f"\t{region['start']}\t{region['stop']}\t{region['name']}\t{percent_Ns}\t{fasta}\n")

def main(args=None):
    args = parse_args(args)
    count_Ns_in_region(
        args.FILE_IN, args.FILE_OUT, args.REGIONS
    )


if __name__ == "__main__":
    sys.exit(main())