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

<!-- ************************************************************************
***** controllerType='FORMVIEW' or 'FIXEDLISTVIEW'  > subView **********
*****                   gen-cell-table common                 **********
************************************************************************-->
	
<xsl:template match="subView[customClass!='MDKLabel']" mode="gen-table-cell">
	<xsl:param name="controllerId"/>
	<xsl:param name="viewId"/>
	<xsl:param name="posY"/>

	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] (controllerId=<xsl:value-of select="$controllerId"/>,posY=<xsl:value-of select="$posY"/>,viewId=<xsl:value-of select="$viewId"/>) </xsl:comment>

	<xsl:variable name="labelSuffix"><xsl:if test="@visibleLabel='false'">-noLabel</xsl:if></xsl:variable>
	<xsl:variable name="labelViewHeight">
		<xsl:choose>
			<xsl:when test="@visibleLabel='true'"><xsl:value-of select="@labelViewHeight"></xsl:value-of></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="cellMargin"><xsl:value-of select="../../@cellMargin * 2"/></xsl:variable>
		
	<xsl:variable name="viewPrefix">
		<xsl:text>FWK-</xsl:text>
		<xsl:value-of select="$viewId"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="customClass"/>Cell<xsl:value-of select="$labelSuffix"/>
	</xsl:variable>

	<tableViewCell contentMode="scaleToFill" selectionStyle="blue" hidesAccessoryWhenEditing="NO" indentationLevel="1" indentationWidth="0.0" rowHeight="{@height + $labelViewHeight + $cellMargin}">

		<xsl:attribute name="customClass">MFCell1ComponentHorizontal</xsl:attribute>
		<xsl:attribute name="reuseIdentifier"><xsl:value-of select="customClass"/>Cell<xsl:value-of select="$labelSuffix"/></xsl:attribute>

		<xsl:attribute name="id"><xsl:value-of select="$viewPrefix"></xsl:value-of></xsl:attribute>

        <attributedString key="userComments">
            <fragment >
           		<string key="content">*** Definition of the height of this cell ***
	           		Find the configurationName of the item having typeName='<xsl:value-of select="customClass"/>Cell', in the file "resources/plist/sections/section-<xsl:value-of select="../../@name"/>.plist" .      
	           		Then, find the height of this cell in the file whose name is "conf-[configurationName]cell.plist", in the folder "resources/plist/configuration"  
           		</string>
				<attributes>
                     <color key="NSColor" red="1" green="0" blue="0" alpha="1" colorSpace="calibratedRGB"/>
                     <font key="NSFont" size="12" name="Helvetica"/>
                     <paragraphStyle key="NSParagraphStyle" alignment="natural" lineBreakMode="wordWrapping" baseWritingDirection="natural" lineHeightMultiple="1"/>
                 </attributes>
            </fragment>
        </attributedString>

		<rect key="frame" x="10" y="10" width="320" height="{@height + $labelViewHeight + $cellMargin}">
			<!--   xsl:attribute name="y"><xsl:value-of select="$posY"/></xsl:attribute -->
		</rect>
		<autoresizingMask key="autoresizingMask"/>
		
		<tableViewCellContentView key="contentView" opaque="NO" clipsSubviews="YES" multipleTouchEnabled="YES" contentMode="center">
			<xsl:attribute name="id"><xsl:value-of select="$viewPrefix"/>-Content</xsl:attribute>
			<xsl:attribute name="tableViewCell">
				<xsl:value-of select="$viewPrefix"/>
			</xsl:attribute>
			
			<rect key="frame" y="0.0" x="10" width="{@width}" height="{@height + $labelViewHeight}"/>
			<autoresizingMask key="autoresizingMask"/>
			<subviews>
				<xsl:apply-templates select="." mode="gen-table-cell-view">
					<xsl:with-param name="controllerId"><xsl:value-of select="$controllerId"/></xsl:with-param>
					<xsl:with-param name="viewId"><xsl:value-of select="$viewPrefix"/></xsl:with-param>
				</xsl:apply-templates>
			</subviews>
			
			<xsl:apply-templates select="." mode="gen-table-cell-constraints">
				<xsl:with-param name="parentId"><xsl:value-of select="$viewPrefix"/>-Content</xsl:with-param>
				<xsl:with-param name="viewId"><xsl:value-of select="$viewPrefix"/></xsl:with-param>
			</xsl:apply-templates>
			
		</tableViewCellContentView>
		
		<xsl:apply-templates select="." mode="gen-table-cell-runtime-attributes"/>
		<xsl:apply-templates select="." mode="gen-table-cell-connections">
			<xsl:with-param name="viewId"><xsl:value-of select="$viewPrefix"/></xsl:with-param>
		</xsl:apply-templates>

	</tableViewCell>

</xsl:template>


<xsl:template match="subView[customClass!='MDKLabel']" mode="gen-table-cell-view">
	<xsl:param name="controllerId"/>
	<xsl:param name="viewId"/>
	
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-view' (controllerId=<xsl:value-of select="$controllerId"/>, viewId=<xsl:value-of select="$viewId"/>)</xsl:comment>

	<xsl:if test="@visibleLabel='true'">
	<label contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO" customClass="MDKLabel" opaque="NO">
		<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
		<constraints>
			<constraint constant="{@labelViewHeight}" firstAttribute="height">
				<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-L-height</xsl:attribute>
	    	    <xsl:attribute name="multiplier">1</xsl:attribute>
			</constraint>
		</constraints>
      	<fontDescription key="fontDescription" type="system" pointSize="12"/>
     	<color key="textColor" red="0.0" green="0.47843137250000001" blue="1" alpha="1" colorSpace="calibratedRGB"/>
	</label>
	</xsl:if>
	
	<xsl:apply-templates select="." mode="gen-table-cell-view-type">
		<xsl:with-param name="controllerId"><xsl:value-of select="$controllerId"/></xsl:with-param>
		<xsl:with-param name="viewId"><xsl:value-of select="$viewId"/></xsl:with-param>
	</xsl:apply-templates>
	
</xsl:template>

<xsl:template match="subView[customClass!='MDKLabel']" mode="gen-table-cell-view-type" priority="1">
		<xsl:param name="controllerId"/>
		<xsl:param name="viewId"/>
	
	<view contentMode="scaleToFill" translatesAutoresizingMaskIntoConstraints="NO">
		<xsl:attribute name="customClass"><xsl:value-of select="customClass"/></xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
		<xsl:apply-templates select="." mode="gen-table-cell-view-connection-outlet">
			<xsl:with-param name="controllerId"><xsl:value-of select="$controllerId"/></xsl:with-param>
			<xsl:with-param name="viewId"><xsl:value-of select="$viewId"/></xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="." mode="gen-table-cell-view-runtime-attributes"/>
		<xsl:if test="customClass = 'MDKFixedList'">
		<constraints>
			<constraint constant="{@height}" firstAttribute="height">
				<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-height</xsl:attribute>
	    	    <xsl:attribute name="multiplier">1</xsl:attribute>
			</constraint>
		</constraints>
		</xsl:if>
	</view>
</xsl:template>

<xsl:template match="subView[customClass!='MDKLabel']" mode="gen-table-cell-constraints">
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
	        <xsl:attribute name="constant">0</xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="trailing" secondAttribute="trailing" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-trailing-trailing</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	        <xsl:attribute name="constant">0</xsl:attribute>
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
	        <xsl:attribute name="constant"><xsl:value-of select="$cellMargin" /></xsl:attribute>
	        <xsl:attribute name="multiplier">1</xsl:attribute>
	    </constraint>      

	    <constraint firstAttribute="trailing" secondAttribute="trailing" >
	        <xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-trailing-trailing</xsl:attribute>
	        <xsl:attribute name="firstItem"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
	        <xsl:attribute name="secondItem"><xsl:value-of select="$parentId"/></xsl:attribute>
	        <xsl:attribute name="constant">-<xsl:value-of select="$cellMargin" /></xsl:attribute>
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


<xsl:template match="subView[customClass!='MDKLabel']" mode="gen-table-cell-connections">
	<xsl:param name="viewId"/>
	
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-connections' (viewId=<xsl:value-of select="$viewId"/>)</xsl:comment>
	
	<connections>
		<xsl:if test="@visibleLabel = 'true'">
		<outlet property="label">
			<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-L-outlet</xsl:attribute>
			<xsl:attribute name="destination"><xsl:value-of select="$viewId"/>-L</xsl:attribute>
		</outlet>
		</xsl:if>
		<outlet> 
			<xsl:attribute name="property">componentView</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$viewId"/>-C-outlet</xsl:attribute>
			<xsl:attribute name="destination"><xsl:value-of select="$viewId"/>-C</xsl:attribute>
		</outlet>
	</connections>
	
</xsl:template>


<xsl:template match="*" mode="gen-table-cell-view" priority="-900">
	<xsl:param name="controllerId"/>
	<xsl:param name="viewId"/>
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-view' (controllerId=<xsl:value-of select="$controllerId"/>, viewId=<xsl:value-of select="$viewId"/>)</xsl:comment>
</xsl:template>


<xsl:template match="*" mode="gen-table-cell-constraints" priority="-900">
	<xsl:param name="parentId"/>
	<xsl:param name="viewId"/>
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-constraints' (parentId=<xsl:value-of select="$parentId"/>, viewId=<xsl:value-of select="$viewId"/>)</xsl:comment>
</xsl:template>


<xsl:template match="*" mode="gen-table-cell-runtime-attributes" priority="-900">
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-runtime-attributes'</xsl:comment>
</xsl:template>


<xsl:template match="*" mode="gen-table-cell-view-connection-outlet" priority="-900">
	<xsl:param name="controllerId"/>
	<xsl:param name="viewId"/>
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-view-connection-outlet' (controllerId=<xsl:value-of select="$controllerId"/>, viewId=<xsl:value-of select="$viewId"/>)</xsl:comment>
</xsl:template>


<xsl:template match="*" mode="gen-table-cell-view-runtime-attributes" priority="-900">
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-view-runtime-attributes'</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="gen-table-cell-connections" priority="-900">
	<xsl:param name="viewId"/>
	<xsl:comment> [cell-common.xsl] subView[customClass='<xsl:value-of select="customClass"/>'] mode='gen-table-cell-connections'</xsl:comment>
</xsl:template>

</xsl:stylesheet>