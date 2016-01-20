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
		
<xsl:include href="ui/component/mftextbox.xsl"/>
<xsl:include href="ui/component/mfphotothumbnail.xsl"/>
<xsl:include href="ui/component/mfurl.xsl"/>
<xsl:include href="ui/component/mfmail.xsl"/>
<xsl:include href="ui/component/mfphone.xsl"/>
<xsl:include href="ui/component/mffixedlist.xsl"/>
<xsl:include href="ui/component/mflist1d.xsl"/>
<xsl:include href="ui/component/mflist2d.xsl"/>
<xsl:include href="ui/component/button.xsl"/>
<xsl:include href="ui/component/mfspinner.xsl"/>
<xsl:include href="ui/component/mfradioenum.xsl"/>
<xsl:include href="ui/component/mfposition.xsl"/>
<xsl:include href="ui/component/mfcheckbox.xsl"/>
<xsl:include href="ui/component/mfdatepicker.xsl"/>
<xsl:include href="ui/component/mfenumimage.xsl"/>
<xsl:include href="ui/component/mfinteger.xsl"/>
<xsl:include href="ui/component/mfdouble.xsl"/>
<xsl:include href="ui/component/mfslider.xsl"/>
<xsl:include href="ui/component/mfwebview.xsl"/>
<xsl:include href="ui/component/mfmultilinetext.xsl"/>
<xsl:include href="ui/component/mfnumberpicker.xsl"/>
<xsl:include href="ui/component/mfsignature.xsl"/>
<xsl:include href="ui/component/mfsearchspinner.xsl"/>
<xsl:include href="ui/component/mfphotolist.xsl"/>
<xsl:include href="ui/component/mflabel.xsl"/>
<xsl:include href="commons/replace-all.xsl"/>


<xsl:template match="visualfield" mode="display-visualfields" >
	<xsl:apply-templates select="." mode="create-label" />
	<xsl:apply-templates select="." mode="create-component" />
</xsl:template>

<xsl:template match="visualfield" mode="display-visualfields-combo" >
	<xsl:apply-templates select="." mode="create-component" />
</xsl:template>

<xsl:template match="visualfield[create-label = 'true']" mode="create-label" >
	<xsl:text>&lt;TextBlock x:Name="</xsl:text>
	<xsl:value-of select="label"/>
	<xsl:text>" Grid.Row="</xsl:text>
	<xsl:value-of select="label-position"/>
	<xsl:text>" Grid.Column="0"</xsl:text> 
	<xsl:text> VerticalAlignment="Center"</xsl:text>
	<xsl:text> HorizontalAlignment="Center"</xsl:text>
	<xsl:text> Text="{Binding Path=</xsl:text>
	<xsl:value-of select="property-name-c"/>
	<xsl:text>.Label}" &#47;&gt;</xsl:text>
</xsl:template>		


<xsl:template match="visualfield" mode="create-label" >	
</xsl:template>	


<xsl:template match="visualfield" mode="create-row-definition" >
	<xsl:if test="create-label = 'true'">
	<xsl:text>&lt;RowDefinition Height="Auto" &#47;&gt;</xsl:text>
	</xsl:if>
	<xsl:text>&lt;RowDefinition Height="Auto" &#47;&gt;</xsl:text>
</xsl:template>

	
<xsl:template match="layout" mode="include-data-template">
	<xsl:text>&lt;ResourceDictionary  Source="./</xsl:text>
	<xsl:value-of select="full-name"/>
	<xsl:text>.xaml" &#47;&gt;</xsl:text>
</xsl:template>

</xsl:stylesheet>