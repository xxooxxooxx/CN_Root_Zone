#!/bin/bash

### https://blog.bgme.me/posts/2020/precautions-for-registering-domains/

wget https://data.iana.org/TLD/tlds-alpha-by-domain.txt
grep -v '#' tlds-alpha-by-domain.txt | xargs -n1 whois | tee tlds-whois.txt

grep -n "% IANA WHOIS server" tlds-whois.txt | awk 'BEGIN {FS=":"} {print $1}' | tr '\n' ' ' | xargs csplit -n 4 -z tlds-whois.txt
mkdir tmp && mv xx* tmp && mkdir tmp/r

function getCNTlds(){
    fn=$1
    domain=$(grep "domain:" ${fn} | sed -e "s/domain:       //g")
    CN=$(grep "\bChina\b" ${fn})
    HK=$(grep "\bHong Kong\b" ${fn})
    MC=$(grep "\bMacao\b" ${fn})
    [ "${CN}" != "" -o "${HK}" != "" -o "${MC}" != "" ] && \
        cp ${fn} r/${domain}
}
cd tmp
xxs=$(ls xx*)
for xx in ${xxs}
    do
        getCNTlds ${xx}
    done
rm r/CV r/KN

cd r
cat * | grep "No match found for" -v | grep "#" -v > ../../china-tlds-whois.txt
ls * > ../../china-tlds.txt
cd ../../
rm -r tmp
