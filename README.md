# DMARCscan
Bulk DMARC Scanner

# Background
During my last year bug hunting activity, missing DMARC on email domain is vulnerability that worth to be reported to program owners. According to [Bugcrowd VRT](https://bugcrowd.com/vulnerability-rating-taxonomy), this finding has **P4** Priority.
```
Server Security Misconfiguration > Mail Server Misconfiguration > Email Spoofing to Inbox due to Missing or Misconfigured DMARC on Email Domain
```
![Missing DMARC](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEifRzuXQbLKDfIsIiwH_DP-I85iZvAzhP1J_S0QTBgDrFj3XLivjHlW9PhE2SHLhATLzWuZ2Hk05JxZePeu3urVg9Xrcc5wwr9xbc4_CCPwTGz-YbzrD6ZYqcz7CZJ9CcLLSLy48hOzsjA0R6QmeXtlCOrXCpN9btZF03JwICZhi10PN-11QYhka63YRA/s700/dmarc%20not%20enabled.png "Missing DMARC")

So, i create this tool to check is DMARC enabled or missing from domain.

# How to Use
Print Help
```
┌──(miku㉿nakano)-[~/DMARCscan]
└─$ bash dmarcscan.sh 

DMARCscan - Bulk DMARC Scanner
Codename : Asuka

Example: bash dmarcscan.sh -l domain.txt -t 30
options:
-l     Files contain lists of domain.
-d     Single domain check
-t     Adjust multi process. Default is 15
-h     Print this Help.
```
Bulk DMARC check from the lists.
```
┌──(miku㉿nakano)-[~/DMARCscan]
└─$ bash dmarcscan.sh -l domains.txt -t 30

DMARCscan - Bulk DMARC Scanner
Codename : Asuka

1688.com - DMARC not Exist
airtable.com - DMARC Exist
airbnbcitizen.com - DMARC not Exist
9apps.com - DMARC not Exist
aaf.cloud - DMARC not Exist
alibaba-inc.com - DMARC Exist
algolianet.com - DMARC Exist
algolia.net - DMARC Exist
alicdn.com - DMARC not Exist
aliexpress.com - DMARC Exist
......
```
Single domain check
```
┌──(miku㉿nakano)-[~/DMARCscan]
└─$ bash dmarcscan.sh -d linuxsec.org

DMARCscan - Bulk DMARC Scanner
Codename : Asuka

linuxsec.org - DMARC Exist
```
# Screenshot
![Scan DMARC](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhRTT0PyuR3HxjtqO5rAz6T59WUWc8PY-VclftjtXyo0-0MAcU3GWhJqqkZuDSz4r7V1Zcos-6-6Ghv0z6EClorGOE_Ri2_gtSFtv9W4l9aH4S4kGUrugQSVf9DHKEKVDRko22pxL43jcvXw5TXrQ5iaEnWuTtUp1cl1NZibYZyjuCY3Vgeb6CMHmmOzg/s700/mass%20scan%20dmarc.png "Scan DMARC")

Feel free to contribute if you want to improve this tools.
