<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" indent="yes"
	doctype-public="-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	doctype-system="http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd"
	omit-xml-declaration="no"/>	

<xsl:template match="join-tables">
declare
    CURSOR fks IS
select constraint_name, table_name from user_constraints where constraint_type = 'R' and table_name in (
<xsl:for-each select="table">
	<xsl:text>'</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>'</xsl:text>
	<xsl:if test="position() != last()">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:for-each>
<xsl:text>);</xsl:text>
begin
  FOR fk IN fks
  LOOP
      execute immediate 'ALTER TABLE ' || fk.table_name ||  ' DROP CONSTRAINT ' || fk.constraint_name ;
  END LOOP;
end;
/


<xsl:apply-templates select="./table/foreign-keys/foreign-key"/>

</xsl:template>

<xsl:template match="foreign-key">
  <xsl:text>ALTER TABLE </xsl:text><xsl:value-of select="../../@name"/>
  <xsl:text> ADD CONSTRAINT </xsl:text><xsl:value-of select="./@name"/>
  <xsl:text> FOREIGN KEY(</xsl:text>
  <!-- BOUCLE -->
  <xsl:for-each select="./field">
  	<xsl:value-of select="."/>
	<xsl:if test="position() != last()">
		<xsl:text>,</xsl:text>
	</xsl:if>
  </xsl:for-each>  
  <xsl:text>) REFERENCES </xsl:text><xsl:value-of select="./table-ref/@name"/>
  <xsl:text>(</xsl:text>
  <!-- BOUCLE -->
  <xsl:for-each select="./table-ref/field">
  	<xsl:value-of select="."/>
	<xsl:if test="position() != last()">
		<xsl:text>,</xsl:text>
	</xsl:if>
  </xsl:for-each>  
  <xsl:text>)</xsl:text>
  <xsl:if test="@delete-cascade = 'true'">
  	<xsl:text> ON DELETE CASCADE </xsl:text>
  </xsl:if>
  <xsl:text>;
  </xsl:text>
</xsl:template>

</xsl:stylesheet>