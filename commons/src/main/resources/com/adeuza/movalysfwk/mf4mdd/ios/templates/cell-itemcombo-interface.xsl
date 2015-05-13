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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="text"/>

<xsl:include href="commons/file-header.xsl"/>
<xsl:include href="commons/imports.xsl"/>
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/constants.xsl"/>

<xsl:include href="ui/storyboard/views/view-mftextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfposition.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfsendmailtextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfbrowseurltextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfcallphonenumber.xsl"/>
<xsl:include href="ui/storyboard/views/view-mflabel.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfscanner.xsl"/>

<xsl:template match="controller[@controllerType='COMBOVIEW']">

<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="itemCellClassName"/>.h</xsl:with-param>
</xsl:apply-templates>

@interface <xsl:value-of select="itemCellClassName"/> : 
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">class-signature</xsl:with-param>
	<xsl:with-param name="defaultSource">MFBindingViewAbstract&#13;</xsl:with-param>
</xsl:call-template>	
	
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

<xsl:apply-templates select="sections/section/subViews/subView[@xsi:type='miosEditableView' and (localization='DEFAULT' or localization='LIST')]" mode="propertiesForCellInterface"/>

<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">other-methods</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
</xsl:call-template>

@end

</xsl:template>


<xsl:template match="subView[customClass]|component[customClass]" mode="propertiesForCellInterface">

	@property (strong, nonatomic) IBOutlet MFLabel *<xsl:value-of select="./propertyName"/>Label<xsl:text>;&#13;</xsl:text>

	@property (strong, nonatomic) IBOutlet <xsl:value-of select="./customClass"/> *<xsl:value-of select="./propertyName"/><xsl:text>;&#13;</xsl:text>

</xsl:template>

<xsl:template match="*" mode="propertiesForCellInterface" priority="-900">
//GENERATION ERROR !!!
</xsl:template>


</xsl:stylesheet>