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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="ui/section/common-group.xsl"/>
	<!-- This xsl manages configuration of the binding of the cell properties, 
		configuration declared in the section plist -->

	<!-- Conditions: * Cell type : MFCell1ComponentHorizontal * Form type : 
		form, fixedlist -->
	<xsl:template
		match="subView[(cellType = 'MFCell1ComponentHorizontal') and not(ancestor::controller)]"
		mode="cellPropertyLabelBinding-for-plist">
		<key>cellPropertyBinding</key>
		<xsl:choose>
			<xsl:when test="../../@isNoTable = 'true'">
				<string>
					<xsl:value-of select="propertyName" />_label_<xsl:value-of select="../../@name" />
				</string>
			</xsl:when>
			<xsl:otherwise>
				<string>label</string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template
		match="subView[(cellType = 'MFCell1ComponentHorizontal') and not(ancestor::controller)]"
		mode="cellPropertyValueBinding-for-plist">
		<key>cellPropertyBinding</key>
		<xsl:choose>
			<xsl:when test="../../@isNoTable = 'true'">
				<string>
					<xsl:value-of select="propertyName" />_<xsl:value-of select="../../@name" />
				</string>
			</xsl:when>
			<xsl:otherwise>
				<string>componentView</string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- Conditions: * Cell type : MFCellComponentFixedList * Form type : form, 
		fixedlist -->
	<xsl:template
		match="subView[cellType = 'MFCellPhotoFixedList' and not(ancestor::controller)]"
		mode="cellPropertyLabelBinding-for-plist">
		<key>cellPropertyBinding</key>
		<xsl:choose>
			<xsl:when test="../../@isNoTable = 'true'">
				<string>
					<xsl:value-of select="propertyName" />_label_<xsl:value-of select="../../@name" />
				</string>
			</xsl:when>
			<xsl:otherwise>
				<string>label</string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template
		match="subView[cellType = 'MFCellPhotoFixedList' and not(ancestor::controller)]"
		mode="cellPropertyValueBinding-for-plist">
		<key>cellPropertyBinding</key>
		<xsl:choose>
			<xsl:when test="../../@isNoTable = 'true'">
				<string>
					<xsl:value-of select="propertyName" />_<xsl:value-of select="../../@name" />
				</string>
			</xsl:when>
			<xsl:otherwise>
				<string>componentView</string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- 	Conditions: * Cell type : MFCellComponentPickerList * Form type : form,  -->
<!-- 		pickerlist -->
	<xsl:template
		match="subView[cellType = 'MFCellComponentPickerList' and not(ancestor::controller)]"
		mode="cellPropertyLabelBinding-for-plist">
		<key>cellPropertyBinding</key>
		<xsl:choose>
			<xsl:when test="../../@isNoTable = 'true'">
				<string>
					<xsl:value-of select="propertyName" />_label_<xsl:value-of select="../../@name" />
				</string>
			</xsl:when>
			<xsl:otherwise>
				<string>label</string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template
		match="subView[cellType = 'MFCellComponentPickerList' and not(ancestor::controller)]"
		mode="cellPropertyValueBinding-for-plist">
		<key>cellPropertyBinding</key>
		<xsl:choose>
			<xsl:when test="../../@isNoTable = 'true'">
				<string>
					<xsl:value-of select="propertyName" />_<xsl:value-of select="../../@name" />
				</string>
			</xsl:when>
			<xsl:otherwise>
				<string>componentView</string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- Conditions: * Cell type : MFPhotoThumbnailCell * Form type : form, 
		fixedlist -->
	<xsl:template
		match="subView[cellType = 'MFPhotoThumbnailCell' and not(ancestor::controller)]"
		mode="cellPropertyLabelBinding-for-plist">
		<key>cellPropertyBinding</key>
		<string>label</string>
	</xsl:template>

	<xsl:template
		match="subView[cellType = 'MFPhotoThumbnailCell' and not(ancestor::controller)]"
		mode="cellPropertyValueBinding-for-plist">
		<key>cellPropertyBinding</key>
		<string>componentView</string>
	</xsl:template>

	<!-- Conditions: * Cell type : MFPositionCell * Form type : form, fixedlist -->
	<xsl:template
		match="subView[cellType = 'MFPositionCell' and not(ancestor::controller)]"
		mode="cellPropertyLabelBinding-for-plist">
		<key>cellPropertyBinding</key>
		<string>label</string>
	</xsl:template>

	<xsl:template
		match="subView[cellType = 'MFPositionCell' and not(ancestor::controller)]"
		mode="cellPropertyValueBinding-for-plist">
		<key>cellPropertyBinding</key>
		<string>componentView</string>
	</xsl:template>

	<!-- * Kind of cell: cells of list item * Form type : list -->
	<xsl:template match="subView[ancestor::controller]" mode="cellPropertyLabelBinding-for-plist">
		<key>cellPropertyBinding</key>
		<string><xsl:value-of select="propertyName" />Label</string>
	</xsl:template>

	<xsl:template match="subView[ancestor::controller]" mode="cellPropertyValueBinding-for-plist">
		<key>cellPropertyBinding</key>
		<string>
			<xsl:value-of select="propertyName" />
		</string>
	</xsl:template>

	<xsl:template match="subView" mode="cellPropertyLabelBinding-for-plist">
		<xsl:comment>
			TODO: ERROR NOT MANAGED (mode:cellPropertyLabelBinding-for-plist,
			cellType:
			<xsl:value-of select="cellType" />
			, cell-property-binding.xsl)
		</xsl:comment>
	</xsl:template>

	<xsl:template match="subView" mode="cellPropertyValueBinding-for-plist">
		<xsl:comment>
			TODO: ERROR NOT MANAGED (mode:cellPropertyValueBinding-for-plist,
			cellType:
			<xsl:value-of select="cellType" />
			, cell-property-binding.xsl)
		</xsl:comment>
	</xsl:template>
</xsl:stylesheet>
