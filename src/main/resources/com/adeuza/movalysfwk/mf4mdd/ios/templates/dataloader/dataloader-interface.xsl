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

<xsl:output method="text"/>

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/file-header.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/non-generated.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/ios/templates/commons/constants.xsl"/>

	<xsl:template match="dataloader-interface">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name"/>.h</xsl:with-param>
</xsl:apply-templates>

<xsl:apply-templates select="." mode="declare-protocol-imports"/>

@interface <xsl:value-of select="name"/> : 
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-signature</xsl:with-param>
	<xsl:with-param name="defaultSource">MFAbstractDataLoader&lt;MFDataLoaderProtocol&gt;&#13;</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

	<!-- Load method -->
	<xsl:apply-templates select="." mode="loadMethod"/>

	<!-- Getter for combo -->
	<xsl:apply-templates select="./dataloader-interface/combos/combo" mode="combo-getter"/>	

//@non-generated-start[methods]
<xsl:value-of select="/*/non-generated/bloc[@id='methods']"/>
<xsl:text>//@non-generated-end</xsl:text>

@end

	</xsl:template>
	

<!-- LOADMETHOD (for list) -->
	<xsl:template match="dataloader-interface[type='LIST']" mode="loadMethod">
/**
 * @brief Load data for panel <xsl:value-of select="name"/>
 * @details load data for panel <xsl:value-of select="name"/>
 * @return array
 */			
-(NSFetchedResultsController *) load:(id&lt;MFContextProtocol&gt;)context;
	</xsl:template>

	
<!-- LOADMETHOD (default) -->
	<xsl:template match="dataloader-interface" mode="loadMethod">
/**
 * @brief Load data for panel <xsl:value-of select="name"/>
 * @details load data for panel <xsl:value-of select="name"/>
 * @return <xsl:value-of select="entity-type/name"/>
 */	
-(<xsl:value-of select="entity-type/name"/> *) load:(id&lt;MFContextProtocol&gt;)context;


<xsl:for-each select="combos/combo">
	<xsl:text>-(NSArray *) getList</xsl:text>
	<xsl:value-of select="entity-getter-name"/>
	<xsl:text>:(id&lt;MFContextProtocol&gt;)context;</xsl:text>
</xsl:for-each>

	</xsl:template>
	
	
<!--  COMBO GETTER -->
<xsl:template match="combo" mode="combo-getter">
	<xsl:text>- (NSArray *) getList</xsl:text><xsl:value-of select="entity-getter-name"/>
	<xsl:text>:(id&lt;MFContextProtocol&gt;)context ;</xsl:text>
</xsl:template>
	
	
<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>

</xsl:stylesheet>