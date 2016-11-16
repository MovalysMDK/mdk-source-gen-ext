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


	<!-- THIS STARTS THE CLASS -->
	<xsl:template match="node()[package and name]" mode="declare-class">
		<xsl:text>(function() {&#10;</xsl:text>
		<xsl:text>'use strict'	;&#10;</xsl:text>
		<xsl:apply-templates select="." mode="documentation"/>
		<xsl:text>&#10;//@non-generated-start[jshint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='jshint-override']"/>
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="class-prototype"/>
		<xsl:text>{&#10;</xsl:text>
			<xsl:apply-templates select="." mode="class-body"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>})();&#10;</xsl:text>

	</xsl:template>


	<xsl:template match="node()" mode="class-body">
	
		<xsl:apply-templates select="." mode="factory-constructor"/>

	</xsl:template>

	<!-- ###################################################
						GESTION DE LA DOCUMENTATION
		################################################### -->

	<xsl:template match="node()" mode="documentation">
		<xsl:text>/**&#10;</xsl:text>
		<xsl:text> * </xsl:text>
		<xsl:value-of select="documentation"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text> *&#10;</xsl:text> 
		<xsl:call-template name="copyright"/>
		<xsl:text> *&#10;</xsl:text> 
		<xsl:text> */&#10;</xsl:text> 
	</xsl:template>

	<xsl:template name="copyright">
		<xsl:text disable-output-escaping="yes"><![CDATA[ * <p>Copyright (c) 2010</p>]]></xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ * <p>Company: Adeuza</p>]]></xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>


	
	
	<!-- ###################################################
			CONSTRUCTEUR INITIALISANT TOUTE LA FACTORY
	################################################### -->
	<xsl:template match="node()" mode="factory-constructor">
		<xsl:text>&#10;var </xsl:text><xsl:value-of select="name"/><xsl:text> = function </xsl:text><xsl:value-of select="name"/><xsl:text>(){&#10;&#10;</xsl:text>
		
		<xsl:text>&#10;</xsl:text><xsl:value-of select="name"/><xsl:text>._Parent.call(this);&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="attributes"/>
		
		<xsl:text>&#10;&#10;//@non-generated-start[attributes]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='attributes']"/>
		<xsl:text>//@non-generated-end&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="define-property"/>
		
		<xsl:text>&#10;};&#10;</xsl:text>
		
		<xsl:apply-templates select="." mode="class-heritage"/>
		

		<xsl:apply-templates select="." mode="extra-methods"/>


   		<xsl:apply-templates select="." mode="class-closure"/>
   		
	</xsl:template>
	
	
	<!-- ###################################################
						TEMPLATES PAR DEFAUT
		################################################### -->


	<xsl:template match="node()" mode="attributes"/>

	<xsl:template match="node()" mode="define-property"/>
	
	<xsl:template match="node()" mode="class-heritage"/>
	
	<xsl:template match="node()" mode="extra-methods"/>
	
	<xsl:template match="node()" mode="class-closure">
	   	<xsl:text>return </xsl:text><xsl:value-of select="name"/><xsl:text>;&#10;</xsl:text>
	</xsl:template>
	


</xsl:stylesheet>