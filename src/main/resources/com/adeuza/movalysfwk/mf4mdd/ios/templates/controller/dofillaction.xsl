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

<!-- DoFillAction method -->
<xsl:template match="controller" mode="doFillAction-method">
-(void) doFillAction {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">doFillAction</xsl:with-param>
			<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="." mode="generate-doFillAction-body"/>
		</xsl:with-param>
	</xsl:call-template>
}
</xsl:template>	

<xsl:template match="controller[@controllerType='FIXEDLISTVIEW']" mode="generate-doFillAction-body">
</xsl:template>

<!-- DoFillAction body for form controller with a unique section -->	
<xsl:template match="controller[((@controllerType='FORMVIEW' or @controllerType='LISTVIEW') and count(sections/section) = 1)  or @controllerType='SEARCHVIEW']" mode="generate-doFillAction-body">
	MFDataLoaderActionParameter *actionInParameter = [[MFDataLoaderActionParameter alloc] init];
	if ( self.ids != nil ) {
        [actionInParameter setDataIdentifiers: self.ids];
    }
    else {
        [actionInParameter setDataIdentifiers: @[@1]];
    }
    [actionInParameter setDataLoaderClassName: @"<xsl:value-of select="sections/section/dataloader"/>"];
    [[MFApplication getInstance] launchAction:MFAction_MFGenericLoadDataAction withCaller:self withInParameter:actionInParameter];
</xsl:template>
	
<!-- DoFillAction body for list controller -->	
<xsl:template match="controller[@controllerType='LISTVIEW' and count(sections/section) = 1]" mode="generate-doFillAction-body">
	MFDataLoaderActionParameter *actionInParameter = [[MFDataLoaderActionParameter alloc] init];
    [actionInParameter setDataLoaderClassName: @"<xsl:value-of select="sections/section/dataloader"/>"];
    [[MFApplication getInstance] launchAction:MFAction_MFGenericLoadDataAction withCaller:self withInParameter:actionInParameter];
</xsl:template>	

<!-- DoFillAction body for list controller -->	
<xsl:template match="controller[@controllerType='LISTVIEW2D' and count(sections/section) >= 1]" mode="generate-doFillAction-body">
	MFDataLoaderActionParameter *actionInParameter = [[MFDataLoaderActionParameter alloc] init];
    [actionInParameter setDataLoaderClassName: @"<xsl:value-of select="sections/section/dataloader"/>"];
    [[MFApplication getInstance] launchAction:MFAction_MFGenericLoadDataAction withCaller:self withInParameter:actionInParameter];
</xsl:template>	


	
<!-- DoFillAction body for controller with multiples sections -->	
<xsl:template match="controller[@controllerType='FORMVIEW' and count(sections/section) > 1]" mode="generate-doFillAction-body">
	<xsl:text>[[MFApplication getInstance] launchAction:MFAction_MFGenericLoadDataAction withCaller:self withInParameter:@[&#13;</xsl:text>
		<xsl:for-each select="sections/section">
		    [[MFDataLoaderActionParameter alloc] initWithDataIds:@[@1] andDataLoader:@"<xsl:value-of select="dataloader"/>
		    <xsl:text>"]</xsl:text>
		    <xsl:if test="position() != last()">
		    	<xsl:text>,&#13;</xsl:text>
		    </xsl:if>
		</xsl:for-each>
	<xsl:text>]];&#13;</xsl:text>
</xsl:template>	

<!-- DoFillAction body for list controller with multiples sections -->	
<xsl:template match="controller[@controllerType='LISTVIEW' and count(sections/section) > 1]" mode="generate-doFillAction-body">
	<!-- not possible -->
</xsl:template>	

</xsl:stylesheet>