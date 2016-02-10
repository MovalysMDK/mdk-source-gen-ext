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
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.application.RunInitError</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.configuration.CustomConfigurationsHandlerInit</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.configuration.property.Property</import>
		<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.configuration.ConfigurationsHandler</import>
	</xsl:template>

	<xsl:template name="genClass">
/**
 * Does the implementation of custom behaviour to add information in configuration handler
 */
public class CustomConfigurationsHandlerInitImpl implements CustomConfigurationsHandlerInit 
//@non-generated-start[implements]
<xsl:value-of select="non-generated/bloc[@id='implements']"/>
//@non-generated-end
{

//@non-generated-start[attributes]
<xsl:value-of select="non-generated/bloc[@id='attributes']"/>
<xsl:text>//@non-generated-end</xsl:text>
	/**
	 * Complete the {@link ConfigurationsHandler}
	 * @param p_oContext The current context. Never null.
	 * @see com.adeuza.movalys.fwk.mobile.javacommons.application.RunInit#run(com.adeuza.MContext.fwk.mobile.javacommons.application.MMContext)
	 */
	@Override
	public void run(final MContext p_oContext) {
		// All caught exception should be of type RunInitError
		
		ConfigurationsHandler oConfigurationsHandler = ConfigurationsHandler.getInstance();
		//@non-generated-start[runInit]
		<xsl:value-of select="non-generated/bloc[@id='runInit']"/>
		<xsl:text>//@non-generated-end</xsl:text>
	}
	
	//@non-generated-start[methodes]
	<xsl:value-of select="non-generated/bloc[@id='methodes']"/>
	<xsl:text>//@non-generated-end</xsl:text>

 }
</xsl:template>

</xsl:stylesheet>
