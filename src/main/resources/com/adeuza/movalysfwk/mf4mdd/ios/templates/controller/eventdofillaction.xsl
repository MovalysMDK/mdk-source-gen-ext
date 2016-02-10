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

<!-- Sucess DoFillAction method -->
<xsl:template match="controller" mode="successLoadActionMethod">
MFRegister_ActionListenerOnMyLaunchedActionSuccess(MFAction_MFGenericLoadDataAction, succeedLoadDataAction)
- (void) succeedLoadDataAction:(id&lt;MFContextProtocol&gt;) context withCaller:(id)caller andResult:(id)result {
    if ( caller == self){
    <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">sucessDoFillAction</xsl:with-param>
			<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="." mode="generate-sucessLoadDataAction-body"/>
		</xsl:with-param>
	</xsl:call-template>
    }
}
</xsl:template>


<!-- Fail DoFillAction method -->
<xsl:template match="controller" mode="failLoadActionMethod">
MFRegister_ActionListenerOnFailed(MFAction_MFGenericLoadDataAction, failLoadDataAction)
- (void) failLoadDataAction:(id&lt;MFContextProtocol&gt;)context withCaller:(id)caller andResult:(id)result {
	if ( caller == self){
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">failDoFillAction</xsl:with-param>
			<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="." mode="generate-failLoadDataAction-body"/>
		</xsl:with-param>
	</xsl:call-template>
	}
}
</xsl:template>


<!-- Sucess DoFillAction body for controller with a unique section -->	
<xsl:template match="controller[((@controllerType='FORMVIEW' or @controllerType='LISTVIEW' or @controllerType='LISTVIEW2D') and count(sections/section) = 1) or @controllerType='SEARCHVIEW']" mode="generate-sucessLoadDataAction-body">

    [[MFApplication getInstance] launchAction:MFAction_MFUpdateVMWithDataLoaderAction withCaller:self withInParameter:
    [[MFUpdateVMInParameter alloc] initWithDataLoader:@"<xsl:value-of select="sections/section/dataloader"/>
    <xsl:text>" andViewModel:@"</xsl:text>
    <xsl:value-of select="sections/section/viewModel"/>"]];
</xsl:template>
	
<!-- Success DoFillAction body for controller with multiples sections -->	
<xsl:template match="controller[(@controllerType='FORMVIEW' or @controllerType='LISTVIEW' or @controllerType='LISTVIEW2D') and count(sections/section) > 1]" mode="generate-sucessLoadDataAction-body">
	<xsl:text>[[MFApplication getInstance] launchAction:MFAction_MFUpdateVMWithDataLoaderAction withCaller:self withInParameter:@[&#13;</xsl:text>
		<xsl:for-each select="sections/section">
			<xsl:if test="dataloader">
			    [[MFUpdateVMInParameter alloc] initWithDataLoader:@"<xsl:value-of select="dataloader"/>" andViewModel:@"<xsl:value-of select="viewModel"/>
			    <xsl:text>"]</xsl:text>
			    <xsl:if test="position() != last()">
			    	<xsl:text>,&#13;</xsl:text>
			    </xsl:if>
		    </xsl:if>
		</xsl:for-each>
	<xsl:text>]];&#13;</xsl:text>
</xsl:template>	


<!-- Fail DoFillAction body for controller with a unique section -->	
<xsl:template match="controller[((@controllerType='FORMVIEW' or @controllerType='LISTVIEW' or @controllerType='LISTVIEW2D') and count(sections/section) = 1) or @controllerType='SEARCHVIEW']" mode="generate-failLoadDataAction-body">
	
</xsl:template>
	
<!-- Fail DoFillAction body for controller with multiples sections -->	
<xsl:template match="controller[(@controllerType='FORMVIEW' or @controllerType='LISTVIEW' or @controllerType='LISTVIEW2D') and count(sections/section) > 1]" mode="generate-failLoadDataAction-body">

</xsl:template>	

</xsl:stylesheet>