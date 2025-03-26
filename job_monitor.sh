# get sif filename from command line
SIF=${1:-c3b-template.sif}
NPS=${2:-4}
WAIT=10
# Submit the job and capture the sbatch output.
job_output=$(sbatch job_myapp.sh $SIF ${NPS})
echo "sbatch output: $job_output"

# Extract the job ID (assumes output: "Submitted batch job <jobid>")
jobid=$(echo "$job_output" | awk '{print $4}')
echo "Submitted job with ID: $jobid"

job_state=""

# Poll the job state using sacct until it reaches a terminal state.
while true; do
    job_state=$(sacct -j "$jobid" --format=State --noheader | head -n 1 | tr -d ' ')
    echo "Job $jobid state: $job_state"
    
    #Check if the job state starts with any terminal keyword.
    if [[ "$job_state" == COMPLETED* || "$job_state" == FAILED* || "$job_state" == CANCELLED* || "$job_state" == TIMEOUT* ]]; then
        break
    fi
    
    echo "Job $jobid is still running... waiting $WAIT seconds."
    sleep $WAIT
done

echo "Job $jobid has finished with state: $job_state"

echo "Detailed job information:"
# Show additional job information.
sacct -j "$jobid" --format=JobID,JobName,Partition,Account,AllocCPUS,State,ExitCode,Elapsed,Start,End --noheader

echo "Displaying job output log:"
cat apptainer.out