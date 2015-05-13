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

<!-- **********************************************************************
***** controllerType='FORMVIEW' or 'FIXEDLISTVIEW'  > subView **********-->
	
<xsl:template match="subView[(customClass='MFCellPhotoFixedList' or cellType='MFCellPhotoFixedList')]" mode="gen-table-cell-view-runtime-attributes">
	
	<xsl:comment> [cell-fixedlistphotocomponent.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-view-runtime-attributes'</xsl:comment>

	<userDefinedRuntimeAttributes>
		<userDefinedRuntimeAttribute type="number" keyPath="mf.editMode">
			<real key="value" value="0.0" />
		</userDefinedRuntimeAttribute>
		<userDefinedRuntimeAttribute type="number" keyPath="mf.rowHeight">
			<real key="value" value="147" />
		</userDefinedRuntimeAttribute>
		<userDefinedRuntimeAttribute type="boolean" keyPath="mf.canAddItem" value="YES" />
		<userDefinedRuntimeAttribute type="boolean" keyPath="mf.canEditItem" value="YES" />
		<userDefinedRuntimeAttribute type="boolean" keyPath="mf.canDeleteItem" value="YES" />
	</userDefinedRuntimeAttributes>

</xsl:template>

<xsl:template match="subView[(customClass='MFCellPhotoFixedList' or cellType='MFCellPhotoFixedList')]" mode="gen-table-cell-runtime-attributes">

	<xsl:comment> [cell-fixedlistphotocomponent.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-runtime-attributes'</xsl:comment>

	<userDefinedRuntimeAttributes>
		<userDefinedRuntimeAttribute type="string" keyPath="mf.formDescriptorName" value="{linkedType}" /><!-- todo -->
	</userDefinedRuntimeAttributes>

</xsl:template>

</xsl:stylesheet>