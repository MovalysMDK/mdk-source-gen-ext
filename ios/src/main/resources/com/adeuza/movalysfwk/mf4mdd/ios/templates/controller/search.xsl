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

<!-- Search methods -->
<xsl:template match="controller[@controllerType='SEARCHVIEW']" mode="searchpanel-methods">
-(void)validFormAndSearch {
    [[MFApplication getInstance] launchAction:@"<xsl:value-of select="saveActionNames/saveActionName[1]"/>" withCaller:self withInParameter:
     [[MFUpdateVMInParameter alloc] initWithDataLoader:@"<xsl:value-of select="sections/section[1]/dataloader"/>" andViewModel:@"<xsl:value-of select="sections/section[1]/viewModel"/>"]];
	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">searchpanel-validFormAndSearch</xsl:with-param>
	<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
}

-(BOOL)isSearchForm {
    return YES;
}

</xsl:template>	

<xsl:template match="controller[@controllerType='LISTVIEW']" mode="search-methods">
<xsl:if test="hasSearchViewController = 'true'">
-(BOOL)hasSearchForm {
    return YES;
}

-(MFFormSearchViewController *)searchViewController {
<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">searchpanel-validFormAndSearch</xsl:with-param>
	<xsl:with-param name="defaultSource">
	MFFormSearchViewController *searchViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"<xsl:value-of select="searchViewController"/>"];
    return searchViewController;
	</xsl:with-param>
	</xsl:call-template>
    
}
</xsl:if>
</xsl:template>	

<xsl:template match="controller" mode="search-methods">
</xsl:template>

<xsl:template match="controller" mode="searchpanel-methods">
</xsl:template>
</xsl:stylesheet>