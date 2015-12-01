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
	
<xsl:template match="subView[(customClass='MDKFixedList' or cellType='MDKFixedList')]" mode="gen-table-cell-view-runtime-attributes">

	<xsl:comment> [cell-fixedlistcomponent.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-view-runtime-attributes'</xsl:comment>
</xsl:template>

<xsl:template match="subView[(customClass='MDKFixedList' or cellType='MDKFixedList')]" mode="gen-table-cell-runtime-attributes">

	<xsl:comment> [cell-fixedlistcomponent.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-runtime-attributes'</xsl:comment>

</xsl:template>


<xsl:template match="subView[(customClass='MDKFixedList' or cellType='MDKFixedList')]" mode="gen-table-cell-constraints">
	<xsl:param name="parentId"/>
	<xsl:param name="viewId"/>

	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-constraints' (viewId=<xsl:value-of select="$viewId"/>)</xsl:comment>

	<xsl:variable name="cellMargin"><xsl:value-of select="../../@cellMargin"/></xsl:variable>
	<constraints>
	<xsl:choose>
	<xsl:when test="@visibleLabel='true'">
		<constraint firstAttribute="top" secondAttribute="top" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-L-top-top</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="constant"><xsl:value-of select="$cellMargin" /></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="leading" secondAttribute="leading" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-L-leading-leading</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="constant"><xsl:value-of select="$cellMargin" /></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="trailing" secondAttribute="trailing" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-L-trailing</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="constant">-<xsl:value-of select="$cellMargin" /></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>     
    
	    <constraint firstAttribute="top" secondAttribute="bottom" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-bottom-top</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	        <xsl:attribute name="constant">0</xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="leading" secondAttribute="leading" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-leading-leading</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	        <xsl:attribute name="constant">-<xsl:value-of select="$cellMargin" /></xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="trailing" secondAttribute="trailing" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-trailing-trailing</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	        <xsl:attribute name="constant"><xsl:value-of select="$cellMargin" /></xsl:attribute>
	    </constraint>      
	</xsl:when>
	<xsl:otherwise>
		<constraint firstAttribute="top" secondAttribute="top" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-top-top</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="constant"><xsl:value-of select="$cellMargin" /></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="leading" secondAttribute="leading" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-leading-leading</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="constant">0</xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="trailing" secondAttribute="trailing" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-trailing-trailing</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="constant">0</xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>
	</xsl:otherwise>
	</xsl:choose>
		<constraint firstAttribute="bottom" secondAttribute="bottom" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-bottom-bottom</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="constant"><xsl:value-of select="$cellMargin" /></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>
	</constraints>
</xsl:template>
</xsl:stylesheet>