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

	<xsl:output method="text" />
	
	<!-- TEMPLATES DE GÉNÉRATION DE L'HÉRITAGE DE LA CLASSE GÉNÉRÉE -->
	
	<!-- Extends for DISPLAY, DISPLAYSIMPLE and DISPLAYLIST -->
	<xsl:template match="action[action-type='DISPLAY' or action-type='DISPLAYSIMPLE' or action-type='DISPLAYLIST']" mode="superclass">
		<xsl:text>GenericDisplayActionImpl</xsl:text>
	</xsl:template>

	<!-- Extends for DISPLAYDETAIL -->
	<xsl:template match="action[action-type='DISPLAYDETAIL']" mode="superclass">
		<xsl:text>GenericDisplayDetailActionImpl</xsl:text>
	</xsl:template>

	<xsl:template match="action[action-type='SAVEDETAIL']" mode="superclass">
		<xsl:choose>
			<xsl:when test="class/transient='false'">
				<xsl:text>AbstractPersistentSaveDetailActionImpl</xsl:text>
			</xsl:when>

			<xsl:otherwise>
				<xsl:text>AbstractSaveDetailActionImpl</xsl:text>
			</xsl:otherwise> 
		</xsl:choose>

		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="class/implements/interface/@name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="action[action-type='DELETEDETAIL']" mode="superclass">
		<xsl:choose>
			<xsl:when test="class/transient='false'">
				<xsl:text>AbstractPersistentDeleteActionImpl</xsl:text>
			</xsl:when>

			<xsl:otherwise>
				<xsl:text>AbstractDeleteActionImpl</xsl:text>
			</xsl:otherwise> 
		</xsl:choose>

		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="class/implements/interface/@name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="action[action-type='CREATE']" mode="superclass">
		<xsl:text>GenericCreateActionImpl</xsl:text>
	</xsl:template>

	<xsl:template match="action[action-type='COMPUTE']" mode="superclass">
		<xsl:text>GenericActionImpl</xsl:text>
	</xsl:template>
	
	<xsl:template match="action[action-type='DIALOG']" mode="superclass">
		<xsl:text>GenericDisplayDialogImpl</xsl:text>
	</xsl:template>
	
	<xsl:template match="action[action-type='DISPLAYWORKSPACE']" mode="superclass">
		<xsl:text>GenericDisplayActionImpl</xsl:text>
	</xsl:template>

	<xsl:template match="action" mode="interfaces">
		<xsl:value-of select="./implements/interface/@name"/>
	</xsl:template>
</xsl:stylesheet>