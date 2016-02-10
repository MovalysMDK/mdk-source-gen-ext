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

<!-- Entry point for HTML5 ViewModel Generation -->
	<xsl:output method="text"/>

	<xsl:include href="commons/import.xsl"/>
	<xsl:include href="commons/class.xsl"/>
	<xsl:include href="viewmodel/class-definition.xsl"/>
	<xsl:include href="viewmodel/attribute-declaration.xsl"/>
	<xsl:include href="viewmodel/extra-methods.xsl"/>
	<xsl:include href="viewmodel/define-property.xsl"/>
	<xsl:include href="viewmodel/define-property-attribute.xsl"/>
	<xsl:include href="viewmodel/define-property-subvm.xsl"/>
	<xsl:include href="viewmodel/define-property-combo.xsl"/>
	<xsl:include href="viewmodel/define-property-idtostring.xsl"/>
	<xsl:include href="viewmodel/class-closure.xsl"/>
	
	

	<xsl:template match="/">
		<xsl:apply-templates select="viewmodel" mode="declare-class"/>
	</xsl:template>


	<xsl:template match="viewmodel" mode="attributes">
		<xsl:apply-templates select="." mode="attribute-declaration"/>
	</xsl:template>
		

</xsl:stylesheet>