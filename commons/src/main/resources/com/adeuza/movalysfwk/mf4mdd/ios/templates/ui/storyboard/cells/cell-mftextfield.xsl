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

<xsl:template match="subView[customClass='MFTextField']" mode="gen-table-cell-view-type" priority="100">
		<xsl:param name="controllerId"/>
		<xsl:param name="viewId"/>
		
	<textField contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO">
		<xsl:attribute name="customClass"><xsl:value-of select="customClass"/></xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
		<xsl:apply-templates select="." mode="gen-table-cell-view-connection-outlet">
			<xsl:with-param name="controllerId"><xsl:value-of select="$controllerId"/></xsl:with-param>
			<xsl:with-param name="viewId"><xsl:value-of select="$viewId"/></xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="gen-table-cell-view-runtime-attributes"/>
		<xsl:if test="customClass = 'MFFixedList'">
		<constraints>
			<constraint constant="{@height}" firstAttribute="height">
				<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-height</xsl:attribute>
	    	    <xsl:attribute name="multiplier">1</xsl:attribute>
			</constraint>
		</constraints>
		</xsl:if>
	</textField>
						
</xsl:template>

</xsl:stylesheet>