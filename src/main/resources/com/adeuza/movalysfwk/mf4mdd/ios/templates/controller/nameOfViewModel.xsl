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

<!-- nameOfViewModel method -->
<xsl:template match="controller" mode="nameOfViewModel-method">
-(id&lt;MFUIBaseViewModelProtocol&gt;) createViewModel {
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">createVM</xsl:with-param>
		<xsl:with-param name="defaultSource">
			MViewModelCreator *vmCreator = [[MFApplication getInstance] getBeanWithKey:BEAN_KEY_VIEW_MODEL_CREATOR];
			<xsl:apply-templates select="." mode="generate-nameOfViewModel-body"/>
		</xsl:with-param>
	</xsl:call-template>
}
</xsl:template>	

<!-- nameOfViewModel body for form controller with a unique section -->	
<xsl:template match="controller[((@controllerType='FORMVIEW' and count(sections/section) = 1) or @controllerType='SEARCHVIEW') and (./workspaceRole != 'WORKSPACE_DETAIL' and ./workspaceRole != 'WORKSPACE_MASTER')]" mode="generate-nameOfViewModel-body">
	return [vmCreator create<xsl:value-of select="sections/section/viewModel"/>:self];
</xsl:template>
	
<!-- nameOfViewModel body for form controller with multiples sections -->	
<xsl:template match="controller[(@controllerType='FORMVIEW' and count(sections/section) > 1)  and (./workspaceRole != 'WORKSPACE_DETAIL' and ./workspaceRole != 'WORKSPACE_MASTER') ]" mode="generate-nameOfViewModel-body">
	return [vmCreator create<xsl:value-of select="viewModel"/>:self];
</xsl:template>

<!-- nameOfViewModel body for form controller with multiples sections -->	
<xsl:template match="controller[@controllerType='FORMVIEW' and ./workspaceRole = 'WORKSPACE_DETAIL']" mode="generate-nameOfViewModel-body">
   
    <xsl:value-of select="./sections/section[1]/parentViewModelClass"/> *workspaceViewModel = [[MFApplication getInstance] getBeanWithKey:@"<xsl:value-of select="./sections/section[1]/parentViewModelClass"/>"];
	<xsl:apply-templates select="./sections/section" mode="generate-nameOfViewModel-body-workspace"/>
	return workspaceViewModel;
</xsl:template>


<!-- nameOfViewModel body for list controller with a unique section -->	
<xsl:template match="controller[(@controllerType='LISTVIEW' or @controllerType='LISTVIEW2D') and count(sections/section) = 1]" mode="generate-nameOfViewModel-body">
	return [vmCreator create<xsl:value-of select="sections/section/viewModel"/>];
</xsl:template>
	
<!-- nameOfViewModel body for list controller with multiples sections -->	
<xsl:template match="controller[(@controllerType='LISTVIEW' or @controllerType='LISTVIEW2D')  and count(sections/section) > 1]" mode="generate-nameOfViewModel-body">
	return [vmCreator create<xsl:value-of select="viewModel"/>];
</xsl:template>	

<xsl:template match="controller[@controllerType='FIXEDLISTVIEW']" mode="generate-nameOfViewModel-body">
	return [vmCreator create<xsl:value-of select="itemViewModel"/>];
</xsl:template>

<xsl:template match="section" mode="generate-nameOfViewModel-body-workspace">
    workspaceViewModel.<xsl:value-of select="viewModelAttributeInParent"/> =[vmCreator create<xsl:value-of select="viewModel"/>:self];
</xsl:template>

</xsl:stylesheet>