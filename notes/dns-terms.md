# Understanding DNS Terms
From https://www.digitalocean.com/community/tutorials/an-introduction-to-dns-terminology-components-and-concepts

## Domain Name System
The domain name system, more commonly known as "DNS" is the networking system in
place that allows us to resolve human-friendly names to unique addresses.

## Domain Name
A domain name is the human-friendly name that we are used to associating with an
internet resource. For instance, "google.com" is a domain name. Some people will
say that the "google" portion is the domain, but we can generally refer to the
combined form as the domain name.

The URL "google.com" is associated with the servers owned by Google Inc. The
domain name system allows us to reach the Google servers when we type
"google.com" into our browsers.

## IP Address
An IP address is what we call a network addressable location. Each IP address
must be unique within its network. When we are talking about websites, this
network is the entire internet.

IPv4, the most common form of addresses, are written as four sets of numbers,
each set having up to three digits, with each set separated by a dot. For
example, "111.222.111.222" could be a valid IPv4 IP address. With DNS, we map a
name to that address so that you do not have to remember a complicated set of
numbers for each place you wish to visit on a network.

## Top-Level Domain
A top-level domain, or TLD, is the most general part of the domain. The
top-level domain is the furthest portion to the right (as separated by a dot).
Common top-level domains are "com", "net", "org", "gov", "edu", and "io".

Top-level domains are at the top of the hierarchy in terms of domain names.
Certain parties are given management control over top-level domains by ICANN
(Internet Corporation for Assigned Names and Numbers). These parties can then
distribute domain names under the TLD, usually through a domain registrar.

## Hosts
Within a domain, the domain owner can define individual hosts, which refer to
separate computers or services accessible through a domain. For instance, most
domain owners make their web servers accessible through the bare domain
(example.com) and also through the "host" definition "www" (www.example.com).

You can have other host definitions under the general domain. You could have API
access through an "api" host (api.example.com) or you could have ftp access by
defining a host called "ftp" or "files" (ftp.example.com or files.example.com).
The host names can be arbitrary as long as they are unique for the domain.

## SubDomain
A subject related to hosts are subdomains.

DNS works in a hierarchy. TLDs can have many domains under them. For instance,
the "com" TLD has both "google.com" and "ubuntu.com" underneath it. A
"subdomain" refers to any domain that is part of a larger domain. In this case,
"ubuntu.com" can be said to be a subdomain of "com". This is typically just
called the domain or the "ubuntu" portion is called a SLD, which means second
level domain.

Likewise, each domain can control "subdomains" that are located under it. This
is usually what we mean by subdomains. For instance you could have a subdomain
for the history department of your school at "www.history.school.edu". The
"history" portion is a subdomain.

The difference between a host name and a subdomain is that a host defines a
computer or resource, while a subdomain extends the parent domain. It is a
method of subdividing the domain itself.

Whether talking about subdomains or hosts, you can begin to see that the
left-most portions of a domain are the most specific. This is how DNS works:
from most to least specific as you read from left-to-right.

## Fully Qualified Domain Name
A fully qualified domain name, often called FQDN, is what we call an absolute
domain name. Domains in the DNS system can be given relative to one another, and
as such, can be somewhat ambiguous. A FQDN is an absolute name that specifies
its location in relation to the absolute root of the domain name system.

This means that it specifies each parent domain including the TLD. A proper FQDN
ends with a dot, indicating the root of the DNS hierarchy. An example of a FQDN
is "mail.google.com.". Sometimes software that calls for FQDN does not require
the ending dot, but the trailing dot is required to conform to ICANN standards.

## Name Server
A name server is a computer designated to translate domain names into IP
addresses. These servers do most of the work in the DNS system. Since the total
number of domain translations is too much for any one server, each server may
redirect request to other name servers or delegate responsibility for a subset
of subdomains they are responsible for.

Name servers can be "authoritative", meaning that they give answers to queries
about domains under their control. Otherwise, they may point to other servers,
or serve cached copies of other name servers' data.

## Zone File
A zone file is a simple text file that contains the mappings between domain
names and IP addresses. This is how the DNS system finally finds out which IP
address should be contacted when a user requests a certain domain name.

Zone files reside in name servers and generally define the resources available
under a specific domain, or the place that one can go to get that information.

## Records
Within a zone file, records are kept. In its simplest form, a record is
basically a single mapping between a resource and a name. These can map a domain
name to an IP address, define the name servers for the domain, define the mail
servers for the domain, etc.
