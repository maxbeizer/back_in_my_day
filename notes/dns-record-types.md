# DNS Record Types
From https://www.digitalocean.com/community/tutorials/an-introduction-to-dns-terminology-components-and-concepts

## SOA Records
The Start of Authority, or SOA, record is a mandatory record in all zone files.
It must be the first real record in a file (although $ORIGIN or $TTL
specifications may appear above). It is also one of the most complex to
understand.

The start of authority record looks something like this:

```
domain.com.  IN SOA ns1.domain.com. admin.domain.com. (
                                            12083   ; serial number
                                            3h      ; refresh interval
                                            30m     ; retry interval
                                            3w      ; exiry period
                                            1h      ; negative TTL
)
```
Let's explain what each part is for:

`domain.com.`: This is the root of the zone. This specifies that the zone file is
for the domain.com. domain. Often, you'll see this replaced with @, which is
just a placeholder that substitutes the contents of the $ORIGIN variable we
learned about above.

`IN SOA`: The "IN" portion means internet (and will be present in many records).
The SOA is the indicator that this is a Start of Authority record.

`ns1.domain.com.`: This defines the primary master name server for this domain.
Name servers can either be master or slaves, and if dynamic DNS is configured
one server needs to be a "primary master", which goes here. If you haven't
configured dynamic DNS, then this is just one of your master name servers.

`admin.domain.com.`: This is the email address of the administrator for this zone.
The "@" is replaced with a dot in the email address. If the name portion of the
email address normally has a dot in it, this is replace with a "\" in this part
(your.name@domain.com becomes your\name.domain.com).

`12083`: This is the serial number for the zone file. Every time you edit a zone
file, you must increment this number for the zone file to propagate correctly.
Slave servers will check if the master server's serial number for a zone is
larger than the one they have on their system. If it is, it requests the new
zone file, if not, it continues serving the original file.

`3h`: This is the refresh interval for the zone. This is the amount of time that
the slave will wait before polling the master for zone file changes.

`30m`: This is the retry interval for this zone. If the slave cannot connect to
the master when the refresh period is up, it will wait this amount of time and
retry to poll the master.

`3w`: This is the expiry period. If a slave name server has not been able to
contact the master for this amount of time, it no longer returns responses as an
authoritative source for this zone.

`1h`: This is the amount of time that the name server will cache a name error if
it cannot find the requested name in this file.

## A and AAAA Records
Both of these records map a host to an IP address. The "A" record is used to map
a host to an IPv4 IP address, while "AAAA" records are used to map a host to an
IPv6 address.

The general format of these records is this:

```
host     IN      A       IPv4_address
host     IN      AAAA    IPv6_address
```
So since our SOA record called out a primary master server at "ns1.domain.com",
we would have to map this to an address to an IP address since "ns1.domain.com"
is within the "domain.com" zone that this file is defining.

The record could look something like this:

```
ns1     IN  A       111.222.111.222
```
Notice that we don't have to give the full name. We can just give the host,
without the FQDN and the DNS server will fill in the rest with the $ORIGIN
value. However, we could just as easily use the entire FQDN if we feel like
being semantic:

```
ns1.domain.com.     IN  A       111.222.111.222
```
In most cases, this is where you'll define your web server as "www":

```
www     IN  A       222.222.222.222
```
We should also tell where the base domain resolves to. We can do this like this:

```
domain.com.     IN  A       222.222.222.222
```
We could have used the "@" to refer to the base domain instead:

```
@       IN  A       222.222.222.222
```
We also have the option of resolving anything that under this domain that is not
defined explicitly to this server too. We can do this with the "*" wild card:

```
*       IN  A       222.222.222.222
```
All of these work just as well with AAAA records for IPv6 addresses.

## CNAME Records
CNAME records define an alias for canonical name for your server (one defined by
an A or AAAA record).

For instance, we could have an A name record defining the "server1" host and
then use the "www" as an alias for this host:

```
server1     IN  A       111.111.111.111
www         IN  CNAME   server1
```
Be aware that these aliases come with some performance losses because they
require an additional query to the server. Most of the time, the same result
could be achieved by using additional A or AAAA records.

One case when a CNAME is recommended is to provide an alias for a resource
outside of the current zone.

## MX Records
MX records are used to define the mail exchanges that are used for the domain.
This helps email messages arrive at your mail server correctly.

Unlike many other record types, mail records generally don't map a host to
something, because they apply to the entire zone. As such, they usually look
like this:

```
        IN  MX  10   mail.domain.com.
```
Note that there is no host name at the beginning.

Also note that there is an extra number in there. This is the preference number
that helps computers decide which server to send mail to if there are multiple
mail servers defined. Lower numbers have a higher priority.

The MX record should generally point to a host defined by an A or AAAA record,
and not one defined by a CNAME.

So, let's say that we have two mail servers. There would have to be records that
look something like this:

```
        IN  MX  10  mail1.domain.com.
        IN  MX  50  mail2.domain.com.
mail1   IN  A       111.111.111.111
mail2   IN  A       222.222.222.222
```
In this example, the "mail1" host is the preferred email exchange server.

We could also write that like this:

```
        IN  MX  10  mail1
        IN  MX  50  mail2
mail1   IN  A       111.111.111.111
mail2   IN  A       222.222.222.222
```

## NS Records
This record type defines the name servers that are used for this zone.

You may be wondering, "if the zone file resides on the name server, why does it
need to reference itself?". Part of what makes DNS so successful is its multiple
levels of caching. One reason for defining name servers within the zone file is
that the zone file may be actually being served from a cached copy on another
name server. There are other reasons for needing the name servers defined on the
name server itself, but we won't go into that here.

Like the MX records, these are zone-wide parameters, so they do not take hosts
either. In general, they look like this:

```
        IN  NS     ns1.domain.com.
        IN  NS     ns2.domain.com.
```
You should have at least two name servers defined in each zone file in order to
operate correctly if there is a problem with one server. Most DNS server
software considers a zone file to be invalid if there is only a single name
server.

As always, include the mapping for the hosts with A or AAAA records:

```
        IN  NS     ns1.domain.com.
        IN  NS     ns2.domain.com.
ns1     IN  A      111.222.111.111
ns2     IN  A      123.211.111.233
```
There are quite a few other record types you can use, but these are probably the
most common types that you will come across.""
