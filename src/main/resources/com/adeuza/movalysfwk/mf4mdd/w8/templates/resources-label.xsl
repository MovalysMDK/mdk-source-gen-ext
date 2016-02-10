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
	<xsl:include href="commons/replace-all.xsl"/>
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

	<xsl:template match="labels">
	<root>  
			<xsl:call-template name="resource-file-start" />
			<xsl:apply-templates select="label" />
	</root>
	</xsl:template>

	<xsl:template match="label">
		<data>
		<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
		<xsl:attribute name="xml:space">preserve</xsl:attribute>
		  <value><xsl:value-of select="." /></value>
		</data>
		
	</xsl:template>
	
	<xsl:template name="resource-file-start">
		<xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
	    <xsd:import namespace="http://www.w3.org/XML/1998/namespace" />
	    <xsd:element name="root" msdata:IsDataSet="true">
	      <xsd:complexType>
	        <xsd:choice maxOccurs="unbounded">
	          <xsd:element name="metadata">
	            <xsd:complexType>
	              <xsd:sequence>
	                <xsd:element name="value" type="xsd:string" minOccurs="0" />
	              </xsd:sequence>
	              <xsd:attribute name="name" use="required" type="xsd:string" />
	              <xsd:attribute name="type" type="xsd:string" />
	              <xsd:attribute name="mimetype" type="xsd:string" />
	              <xsd:attribute ref="xml:space" />
	            </xsd:complexType>
	          </xsd:element>
	          <xsd:element name="assembly">
	            <xsd:complexType>
	              <xsd:attribute name="alias" type="xsd:string" />
	              <xsd:attribute name="name" type="xsd:string" />
	            </xsd:complexType>
	          </xsd:element>
	          <xsd:element name="data">
	            <xsd:complexType>
	              <xsd:sequence>
	                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
	                <xsd:element name="comment" type="xsd:string" minOccurs="0" msdata:Ordinal="2" />
	              </xsd:sequence>
	              <xsd:attribute name="name" type="xsd:string" use="required" msdata:Ordinal="1" />
	              <xsd:attribute name="type" type="xsd:string" msdata:Ordinal="3" />
	              <xsd:attribute name="mimetype" type="xsd:string" msdata:Ordinal="4" />
	              <xsd:attribute ref="xml:space" />
	            </xsd:complexType>
	          </xsd:element>
	          <xsd:element name="resheader">
	            <xsd:complexType>
	              <xsd:sequence>
	                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
	              </xsd:sequence>
	              <xsd:attribute name="name" type="xsd:string" use="required" />
	            </xsd:complexType>
	          </xsd:element>
	        </xsd:choice>
	      </xsd:complexType>
	    </xsd:element>
	  </xsd:schema>
	  <resheader name="resmimetype">
	    <value>text/microsoft-resx</value>
	  </resheader>
	  <resheader name="version">
	    <value>2.0</value>
	  </resheader>
	  <resheader name="reader">
	    <value>System.Resources.ResXResourceReader, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
	  </resheader>
	  <resheader name="writer">
	    <value>System.Resources.ResXResourceWriter, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
	  </resheader>
	  <data name="ResourceFlowDirection" xml:space="preserve">
	    <value>LeftToRight</value>
	    <comment>Controls the FlowDirection for all elements in the RootFrame. Set to the traditional direction of this resource file's language</comment>
	  </data>
	  <data name="ResourceLanguage" xml:space="preserve">
	    <value>fr-FR</value>
	    <comment>Controls the Language and ensures that the font for all elements in the RootFrame aligns with the app's language. Set to the language code of this resource file's language.</comment>
	  </data>
	</xsl:template>

</xsl:stylesheet>