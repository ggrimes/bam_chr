
chr_ch=Channel
    .of(1..21, 'X', 'Y')

bam_ch=Channel.fromFilePairs('bams/*.{bam,bai}')
{ file -> file.name.replaceAll(/.bam|.bai$/,'') }



process view {
echo true
 input:
 //val bam from bam_ch
  tuple val(sampleId), file(bam) from bam_ch
  each  ctg from chr_ch

 output:
 tuple val("${sampleId}"), file("chr${ctg}_${sampleId}.vcf") into out_ch
"""
echo ${sampleId} ${ctg} ${bam[0]}  > "chr${ctg}_${sampleId}.vcf"
"""
}

//out_ch.groupTuple()

process combine {
 echo true
 publishDir "results"
 input:
 set key, file(samples) from out_ch.groupTuple()
 //path vcfs from out_ch.collect()
 output:
 path "${key}.combine" into comb
 script:
 """
 echo $samples > ${key}.combine
 """


}
