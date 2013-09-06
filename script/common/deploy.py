import sys
import re
import os

def main():
    url = sys.argv[1]
    ssh_url = re.sub(r':.*', '', url)
    template = sys.argv[2]
    run_id = sys.argv[3]

    loc = 0
    arr = re.split(r'[@:]', url)
    if len(arr)>1:
        server_ip = arr[1]
        project_dir = arr[2]
    else:
        loc = 1
        project_dir = arr[0]

    if loc:
        os.system("cd %s; mkdir -p data; mkdir -p script; mkdir -p result' "%(project_dir))
    else:
        os.system("ssh %s 'cd %s; mkdir -p data; mkdir -p script; mkdir -p result' "%(server_ip, project_dir))

    # copy scripts
    scripts = ["eval_str.sh", "workflow_utils.sh", "timediff.py", "notify_by_mail.py", "fasta_split.py", "fastq2fasta.py", "lcs_proc.py"]

    if loc:
        for s in scripts:
            os.system("cp %s %s/script"%(s, project_dir))
    else:
        for s in scripts:
            os.system("scp %s %s/script"%(s, url))

    # fill in template
    template_str = open(template, "r").read()
    template_str = re.sub(r"@PROJECT_DIR@", project_dir, template_str)
    template_str = re.sub(r"@RUN_ID@", run_id, template_str)

    curr_script_name = re.sub("_template.sh", "", template)+"_inst.sh"
    curr_script = open(curr_script_name, "w")
    curr_script.write(template_str)
    curr_script.close()

    if loc:
        pass
        #!!!!!!!!!!!!!TODO
    else:
        os.system("scp %s %s/script"%(curr_script_name, url))
    #os.system("rm %s"%(curr_script_namer))

    # execute
    cmd = "ssh %s 'cd %s; export SCRIPT_DIR=./script; chmod +x ./script/%s; nohup ./script/%s >> nohup.log  2>> nohup.err &' "%(ssh_url, project_dir, curr_script_name, curr_script_name)
    print "executing: %s"%(cmd)
    os.system(cmd)

if __name__ == "__main__":
    main()
