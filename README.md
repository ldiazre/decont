# Decontamination of small-RNA sequencing samples from mouse

## Introduction

In this project, you will be "decontaminating" some small-RNA samples from a couple
of mouse strains (black6 and spretus). "Decontaminating" means removing sequences
we are not interested in from our samples before processing them.

In this case the sequence we will be removed are not really contaminants, but rather
RNA species that are very abundant and that we have no interest in analysing.

To decontaminate a sample, you simply align all your reads to the contaminants list,
as if it were a genome, and *keep the reads that do not align*. These reads that do
not align are the decontaminated reads, and you would use them for your downstream analysis.

The same procedure could be used to remove any type of contaminants, just by
changing the contents of the contaminants database fasta.

The sample names you will be working with are "C57BL_6NJ" and "SPRET_EiJ". You have multiple
files for each because one sequencing run was not enough, so you had to re-sequence your samples,
resulting in technical replicates.

> IMPORTANT: your pipeline should be able to analyse an arbitrary number of samples.

## Setting up your environment

### Conda

You should create a new, empty conda repository. Make sure you have set up 
Bioconda to be able to install the necessary packages. [See this link for details
on setting up conda and bioconda](http://bioconda.github.io/user/install.html).

### Git repository

Your working directory will be under git control. You will first copy this repository
to your GitHub account, and then work on this new copy using it as your remote.

#### Forking this repository

You should start by forking this repository. A git **fork** creates a copy
of the repository *on your own GitHub account*. This copy will become the remote
repository where you will eventually save your work.

You can find the fork button on the top right corner of the repository webpage on GitHub.

Once you fork the project, you will have a copy of the repository on a new URL:

`https://github.com/<your_username>/decont`

#### Adding your instructor as a collaborator

You should now add your instructor as a collaborator in your copy of the repository,
so that she/he can interact with you during the development.

#### Getting help

All interactions with your instructor should be carried out instructor by creating issues in the GitHub
repository (click on the "Issues" tab on the top left of the GitHub repo page),
adding a relevant title and description, **and assigning the issue to your instructor**.

You can assign the issue by clicking on the "Assignees" title on the top right.

> Make sure to check that your instructor appears on the list of possible assignees.

#### Cloning your fork and starting work

You should now **clone** this new repository to obtain a local copy in your machine.

You can then start working on your local copy of the repository.

> Remember to commit often. Don't go crazy about it, but do generate a history of your work.

### Organisation of your files

The repository already contains a folder structure to help you organise your files.
It also contains the list of data files to download, and an incomplete main script
with a draft workflow that you should complete.

> You may need to create extra directories to store some files.

## Your tasks

Your job is to develop a pipeline to decontaminate the downloaded samples, leaving them 
ready for further analysis.

When complete, your pipeline should be able to automatically do the following (list not necessarily in order):

> Remember to activate your conda environment and to always check that you are in the root of your working directory.

- Download the sequencing data files
    - The list of urls is available in `data/urls`
- Download the contaminants database
    - `https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz`
- Merge the fastqs from the same sample into a single file
- Remove the adapters from the data (cutadapt in conda)
- Index the contaminants database (star in conda, as if it were a genome)
- Align the adapter-free reads to the contaminants genome, telling star to output the non-aligned reads in FastQ format (also with star)
- Create a log file with information on trimming and alignment results

> Start by looking a the "scripts/pipeline.sh" script, which is the entry point
> for the pipeline execution.

> The scripts contain comments to guide you in the tasks you need to perform.
> Look for the *#TODO* comments, which indicate parts that need to be modified.

## Once you are done

Once you are done, you should first export a file with your conda environment information.

```shell
conda env export > envs/decont.yaml
```

You should **add** the new file to the staging area, **commit** it to the local repository,
and **push** your changes to the remote repository.

## Hints

### The `basename` command

Basename allows you to obtain the last part of a path, and optionally remove a part of it.
> This should prove very useful to extract the sample IDs from paths.

```shell
# keep the filename only from a path
$ basename out/data/mysample.tar.gz
mysample.tar.gz

# keep the filename only from a path, and remove the extension
$ basename http://mydomain.com/out/data/mysample.tar.gz .tar.gz
mysample

# keep the last directory from a path
$ basename out/star/logs
logs
```

### Merging compressed text files

You can merge compressed text files by using cat:

```shell
cat file1.tar.gz file2.tar.gz > merged.tar.gz
```

### Comparing strings in the `if` control statement

You can compare a variable and a strings inside an if statement by doing `if [ "$myvar" == "hello" ]`

### Telling `wget` where to download

The `-P` argument allows you to give wget a directory where to store the downloaded files.

### Creating directories

You can use the `-p` argument of `mkdir` to create a directory if
it doesn't exist, and do nothing if it does. This is useful so that there
are no errors when running a script many times.

### Final state of your working directory

When you are done, your working directory should look something like this:

> This is just to guide you, it doesn't need to be the exact same.

```shell
.
├── data
│   ├── C57BL_6NJ-12.5dpp.1.1s_sRNA.fastq.gz
│   ├── C57BL_6NJ-12.5dpp.1.2s_sRNA.fastq.gz
│   ├── SPRET_EiJ-12.5dpp.1.1s_sRNA.fastq.gz
│   ├── SPRET_EiJ-12.5dpp.1.2s_sRNA.fastq.gz
│   └── urls
├── log
│   ├── cutadapt
│   │   ├── C57BL_6NJ.log
│   │   └── SPRET_EiJ.log
│   └── pipeline.log
├── Log.out
├── out
│   ├── merged
│   │   ├── C57BL_6NJ.fastq.gz
│   │   └── SPRET_EiJ.fastq.gz
│   ├── star
│   │   ├── C57BL_6NJ
│   │   │   ├── Aligned.out.sam
│   │   │   ├── Log.final.out
│   │   │   ├── Log.out
│   │   │   ├── Log.progress.out
│   │   │   ├── SJ.out.tab
│   │   │   └── Unmapped.out.mate1
│   │   └── SPRET_EiJ
│   │       ├── Aligned.out.sam
│   │       ├── Log.final.out
│   │       ├── Log.out
│   │       ├── Log.progress.out
│   │       ├── SJ.out.tab
│   │       └── Unmapped.out.mate1
│   └── trimmed
│       ├── C57BL_6NJ.trimmed.fastq.gz
│       └── SPRET_EiJ.trimmed.fastq.gz
├── res
│   ├── contaminants.fasta
│   ├── contaminants.fasta.gz
│   └── contaminants_idx
│       ├── chrLength.txt
│       ├── chrNameLength.txt
│       ├── chrName.txt
│       ├── chrStart.txt
│       ├── Genome
│       ├── genomeParameters.txt
│       ├── SA
│       └── SAindex
└── scripts
    ├── download.sh
    ├── index.sh
    ├── merge_fastqs.sh
    └── pipeline.sh
```

## Bonus exercises

These are not required for the completion of the practical, but you can complete them for extra points.

- Replace the loop that downloads the samples data files with a wget one-liner.
- Check if the output already exists before running a command. If it exists, display a message and continue.
