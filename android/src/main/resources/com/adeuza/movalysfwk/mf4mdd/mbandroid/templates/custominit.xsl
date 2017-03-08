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

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/mbandroid/templates/includes/imports.xsl"/>
	<xsl:include href="includes/incremental/nongenerated.xsl"/>

	<xsl:output method="text"/>

	<!-- TEMPLATE PRINCIPAL ......................................................................................... -->

	<xsl:template match="/application">
		<xsl:text>package </xsl:text><xsl:value-of select="./domain/rootPackage"/><xsl:text>;&#13;&#13;</xsl:text>
		<xsl:apply-templates select="." mode="declare-imports" />
		<xsl:call-template name="genClass"/>
	</xsl:template>

	<!-- IMPORTS .................................................................................................... -->

	<xsl:template match="application" mode="declare-extra-imports">
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.CustomInit</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.RunInit</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
	</xsl:template>

	<!-- CLASS ...................................................................................................... -->

	<xsl:template name="genClass">

/**
 * Does the implementation of custom behaviour
 */
public class  CustomInitImpl implements CustomInit 
//@non-generated-start[implements]
<xsl:value-of select="non-generated/bloc[@id='implements']"/>
//@non-generated-end
{
//@non-generated-start[attributes]
<xsl:value-of select="non-generated/bloc[@id='attributes']"/>
<xsl:text>//@non-generated-end</xsl:text>
	/**
	 * Complete the start of the application with custom behaviour
	 * @param p_oContext The current context. Never null.
	 * @see com.adeuza.movalysfwk.mobile.mf4mjcommons.application.RunInit#run(com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext)
	 */
	@Override
	public void run(final MContext p_oContext) {
		// All caught exception should be of type RunInitError
	
		//@non-generated-start[runInit]
		<xsl:value-of select="non-generated/bloc[@id='runInit']"/>
		//@non-generated-end
	}
	
	//@non-generated-start[methods]
	<xsl:value-of select="non-generated/bloc[@id='methods']"/>
	<xsl:value-of select="non-generated/bloc[@id='methodes']"/>
	//@non-generated-end

 }
	</xsl:template>

</xsl:stylesheet>
