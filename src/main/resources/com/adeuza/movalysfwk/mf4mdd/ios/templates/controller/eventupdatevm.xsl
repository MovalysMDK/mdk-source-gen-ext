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

<xsl:template match="controller" mode="successUpdateVMActionMethod">
MFRegister_ActionListenerOnMyLaunchedActionSuccess(MFAction_MFUpdateVMWithDataLoaderAction, succeedUpdateVMAction)
- (void) succeedUpdateVMAction:(id&lt;MFContextProtocol&gt;)context withCaller:(id)caller andResult:(id)result
{
    if (caller == self) {
	 <xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">sucessUpdateVMAction</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:apply-templates select="." mode="generate-sucessUpdateVMAction-body"/>
		</xsl:with-param>
	</xsl:call-template>
    }
}
</xsl:template>

<!-- Sucess succeedUpdateVMAction body (list controller) -->	
<xsl:template match="controller[@controllerType='LISTVIEW' or @controllerType='LISTVIEW2D']" mode="generate-sucessUpdateVMAction-body">
	<xsl:text>[self refresh];&#13;</xsl:text>
</xsl:template>

<!-- Sucess succeedUpdateVMAction body (default) -->	
<xsl:template match="controller" mode="generate-sucessUpdateVMAction-body">
	<xsl:text>[self.viewModel resetChanged];&#13;</xsl:text>
	<xsl:if test="@controllerType!='FIXEDLISTVIEW' and @controllerType!='SEARCHVIEW'">
		<xsl:text>[self.tableView reloadData];&#13;</xsl:text>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>