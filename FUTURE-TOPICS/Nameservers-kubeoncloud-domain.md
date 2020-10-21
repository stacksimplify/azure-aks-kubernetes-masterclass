# Nameservers Azure and AWS
```
# Azure Nameservers
ns1-04.azure-dns.com.
ns2-04.azure-dns.net.
ns3-04.azure-dns.org.
ns4-04.azure-dns.info.     

# AWS Nameservers
ns-1408.awsdns-48.org
ns-458.awsdns-57.com
ns-1767.awsdns-28.co.uk
ns-964.awsdns-56.net
```

## Hosted Zone in AWS
```
kubeoncloud.com
Type: SOA
ns-964.awsdns-56.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400

kubeoncloud.com
Type: NS
ns-964.awsdns-56.net.
ns-1767.awsdns-28.co.uk.
ns-1408.awsdns-48.org.
ns-458.awsdns-57.com.
```