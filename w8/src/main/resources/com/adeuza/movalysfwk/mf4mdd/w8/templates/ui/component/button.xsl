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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
		
		
	<xsl:template match="button" mode="create-button">
		<xsl:if test="./@type!='NAVIGATION' and ./@type!='DELETE' and ./@type!='SAVE'">
			<xsl:text>&lt;Button x:Uid="</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>" HorizontalAlignment="Stretch" Click="</xsl:text>
			<xsl:value-of select="@name"/><xsl:text>_Click</xsl:text>
			<xsl:text>" &#47;&gt;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="button[@type = 'SAVE']" mode="create-button">
		<xsl:if test="/layout/in-workspace = 'false' and /layout/in-multipanel = 'false'">
			<xsl:text>&lt;Button x:Uid="</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>" HorizontalAlignment="Stretch" Click="</xsl:text>
			<xsl:value-of select="@name"/><xsl:text>_Click</xsl:text>
			<xsl:text>" &#47;&gt;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="button[@type = 'DELETE']" mode="create-button">
		<xsl:if test="/layout/in-workspace = 'false' and /layout/in-multipanel = 'false'">
			<xsl:text>&lt;Button x:Uid="</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>" HorizontalAlignment="Stretch" Click="</xsl:text>
			<xsl:value-of select="@name"/><xsl:text>_Click</xsl:text>
			<xsl:text>" &#47;&gt;</xsl:text>
		</xsl:if>
	</xsl:template>
		
	<xsl:template match="button[@type = 'NAVIGATION']" mode="create-navigation">
		<xsl:text>&lt;Button x:Uid="</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>" HorizontalAlignment="Stretch" Command="{Binding </xsl:text>
		<xsl:value-of select="navigation/target/vm-name"/><xsl:text>NavigationCommand}</xsl:text>
		<xsl:text>" &#47;&gt;</xsl:text>
	</xsl:template>

	
	<xsl:template match="buttons" mode="display-buttons">
		<xsl:text>&lt;StackPanel Grid.Row="0" Grid.Column="0" &gt;</xsl:text>
		<xsl:apply-templates select="button" mode="create-button" />
		<xsl:apply-templates select="button" mode="create-navigation" />
		<xsl:text>&lt;&#47;StackPanel&gt;</xsl:text>
	</xsl:template>	
	
	<xsl:template match="buttons" mode="display-buttons-without-navigation">
		<xsl:text>&lt;StackPanel Grid.Row="0" Grid.Column="0" &gt;</xsl:text>
		<xsl:apply-templates select="button" mode="create-button" />
		<xsl:text>&lt;&#47;StackPanel&gt;</xsl:text>
	</xsl:template>
</xsl:stylesheet>