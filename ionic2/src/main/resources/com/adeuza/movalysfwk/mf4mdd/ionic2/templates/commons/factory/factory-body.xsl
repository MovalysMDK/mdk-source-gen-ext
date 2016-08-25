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

	
	<!-- ###################################################
			CONSTRUCTEUR INITIALISANT TOUTE LA FACTORY
	################################################### -->
	<xsl:template match="node()[is-factory='true']" mode="factory-constructor">
	
		<xsl:text>&#10;var </xsl:text><xsl:value-of select="nameFactory"/><xsl:text> = function </xsl:text><xsl:value-of select="nameFactory"/><xsl:text>(){&#10;&#10;</xsl:text>
		
		
		<xsl:apply-templates select="." mode="attributes"/>
				
		<xsl:text>&#10;&#10;//@non-generated-start[factory-instanciation]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='factory-instanciation']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="define-property"/>
		
		<xsl:text>&#10;};&#10;&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="class-heritage"/>	
		
		<xsl:apply-templates select="." mode="mapping"/>
		
		<xsl:apply-templates select="." mode="create-and-update-vm-factory"/>

		<xsl:text>&#10;//@non-generated-start[functions]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='functions']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		<xsl:text>return new </xsl:text><xsl:value-of select="nameFactory"/><xsl:text>();&#10;</xsl:text>
	</xsl:template>

	<!-- ###################################################
						TEMPLATES PAR DEFAUT
		################################################### -->


	<xsl:template match="node()" mode="mapping"/>
	
	<xsl:template match="node()" mode="create-and-update-vm-factory"/>


</xsl:stylesheet>