yum -y install openldap-servers openldap-clients nss-pam-ldapd
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap. /var/lib/ldap/DB_CONFIG
systemctl start slapd
systemctl enable slapd

# Configuration

ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif

# Adding basedomain

ldapadd -x -D cn=Manager,dc=nsm,dc=in -w "master@@321" -f basedomain.ldif

# Adding NSM attributes

ldapadd -Y EXTERNAL -H ldapi:/// -f nsmattribute.ldif 


authconfig --enableldap --enableldapauth --ldapserver=10.0.10.6 --ldapbasedn="dc=nsm,dc=in" --enablemkhomedir --update
