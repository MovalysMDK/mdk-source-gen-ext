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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ex="http://exslt.org/dates-and-times"  extension-element-prefixes="ex"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<!-- *************************************************
*****  
***** ENTRY POINT:
*****  	/storyboard/scenes/*scene/controller[@controllerType='LISTVIEW']
*****  
****************************************************** -->
	
<xsl:output method="xml"/>


<xsl:template match="controller[@controllerType='LISTVIEW']">
	
	<xsl:comment>
		#############################
		Controller type = '<xsl:value-of select="@controllerType"/>' - <xsl:value-of select="@type"/>
		Controller ID =  '<xsl:value-of select="@id"/>'
		View ID =  '<xsl:value-of select="@viewId"/>'
		Generation time = <xsl:value-of  select="ex:date-time()"/>
		#############################		
	</xsl:comment>
	
		
	<viewController sceneMemberID="viewController">
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
		<xsl:attribute name="customClass"><xsl:value-of select="customClass/name"/></xsl:attribute>
		<xsl:attribute name="storyboardIdentifier"><xsl:value-of select="customClass/name"/></xsl:attribute>
		
	    <layoutGuides>
            <viewControllerLayoutGuide type="top">
				<xsl:attribute name="id"><xsl:value-of select="@id"/>-LG-top</xsl:attribute>
            </viewControllerLayoutGuide>
            <viewControllerLayoutGuide type="bottom">
				<xsl:attribute name="id"><xsl:value-of select="@id"/>-LG-bottom</xsl:attribute>
            </viewControllerLayoutGuide>
	    </layoutGuides>
		
				
		<view key="view" contentMode="scaleToFill">
			<xsl:attribute name="id"><xsl:value-of select="@viewId"/></xsl:attribute>
			<xsl:comment>This absolute positioning is used only for the interface builder of XCode. That will be overwritten by the relative positioning defined by the constaints</xsl:comment>
			<rect key="frame" x="0.0" y="0.0">
  				<xsl:attribute name="width"><xsl:value-of select="sections/section/@frameWidth"/></xsl:attribute>
        		 <xsl:attribute name="height"><xsl:value-of select="sections/section/@frameHeight"/></xsl:attribute>
  		     </rect>	

            <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>

            <subviews>
						
				<tableView autoresizesSubviews="NO" clipsSubviews="YES" opaque="NO" translatesAutoresizingMaskIntoConstraints="NO" clearsContextBeforeDrawing="NO" contentMode="scaleToFill" bounces="NO" dataMode="prototypes" 
					style="grouped" separatorStyle="default" >
					<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
					<xsl:attribute name="sectionHeaderHeight"><xsl:value-of select="sections/section/@cellMargin"/></xsl:attribute>
		    		<xsl:attribute name="sectionFooterHeight"><xsl:value-of select="sections/section/@cellMargin"/></xsl:attribute>
		    		<xsl:attribute name="rowHeight"><xsl:value-of select="sections/section/@frameHeight"/></xsl:attribute>
		    		
		    		 <rect key="frame" x="0.0" y="0.0">
		  				<xsl:attribute name="width"><xsl:value-of select="sections/section/@frameWidth"/></xsl:attribute>
		        		 <xsl:attribute name="height"><xsl:value-of select="sections/section/@frameHeight"/></xsl:attribute>
		  		     </rect>	
					<prototypes>		
						<tableViewCell contentMode="scaleToFill" selectionStyle="blue" hidesAccessoryWhenEditing="NO" indentationLevel="1" 
						customClass="MFCell1ComponentHorizontal" accessoryType="disclosureIndicator" >
							<xsl:attribute name="reuseIdentifier"><xsl:value-of select="cellClassName"/></xsl:attribute>
							<xsl:attribute name="customClass"><xsl:value-of select="cellClassName"/></xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-ITM</xsl:attribute>
							<xsl:attribute name="rowHeight"><xsl:value-of select="sections/section/@frameHeight"/></xsl:attribute>
							<xsl:attribute name="indentationWidth"><xsl:value-of select="sections/section/@cellMargin"/></xsl:attribute>
												
							<xsl:comment>This absolute positioning is used only for the interface builder of XCode. That will be overwritten by the relative positioning defined by the constaints</xsl:comment>
							<rect key="frame" >
								<xsl:attribute name="width"><xsl:value-of select="sections/section/@frameWidth"/></xsl:attribute>
								<xsl:attribute name="height"><xsl:value-of select="sections/section/@frameHeight"/></xsl:attribute>
								<xsl:attribute name="x">0</xsl:attribute>
								<xsl:attribute name="y">0</xsl:attribute>
							</rect>
						
		                    <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
		
		                    <tableViewCellContentView key="contentView" opaque="NO" clipsSubviews="YES" multipleTouchEnabled="YES" contentMode="center">
								<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-ITM-C</xsl:attribute>
								<xsl:attribute name="tableViewCell"><xsl:value-of select="@viewId"/>-ITM</xsl:attribute>
		
								<xsl:comment>This absolute positioning is used only for the interface builder of XCode. That will be overwritten by the relative positioning defined by the constaints</xsl:comment>
								<rect key="frame" >
									<xsl:attribute name="width"><xsl:value-of select="sections/section/@frameWidth"/></xsl:attribute>
									<xsl:attribute name="height"><xsl:value-of select="sections/section/@frameHeight"/></xsl:attribute>
									<xsl:attribute name="x">0</xsl:attribute>
									<xsl:attribute name="y">0</xsl:attribute>
								</rect>
								
			                    <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
		                    
								<subviews>
									<xsl:apply-templates select="sections/section/subViews/subView" mode="subview-generation">
										<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
									</xsl:apply-templates>
								</subviews>
								
								<constraints>
									<xsl:apply-templates select="sections/section/subViews/subView"  mode="constraints-generation">
										<xsl:with-param name="cellMargin"><xsl:value-of select="sections/section/@cellMargin"/></xsl:with-param>
										<xsl:with-param name="containerId"><xsl:value-of select="@viewId" />-ITM-C</xsl:with-param>
									</xsl:apply-templates>
								</constraints>
														
							</tableViewCellContentView>
							<connections>
								<xsl:apply-templates select="sections/section/subViews/subView" mode="outlets-generation" >
									<xsl:with-param name="collection">false</xsl:with-param>
								</xsl:apply-templates>
							</connections>
						</tableViewCell>
					</prototypes>
					<connections>
						<outlet property="dataSource">
							<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-TV-OUT-DTS</xsl:attribute>
							<xsl:attribute name="destination"><xsl:value-of select="@id"/></xsl:attribute>
						</outlet>
						<outlet property="delegate">
							<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-TV-OUT-DLG</xsl:attribute>
							<xsl:attribute name="destination"><xsl:value-of select="@id"/></xsl:attribute>
						</outlet>
					</connections>
				</tableView>
												
			</subviews>
			<constraints>
					<xsl:comment>Positioning constraints to give to the tableView '<xsl:value-of select="@viewId"/>-TV' the same size than its containing view '<xsl:value-of select="@viewId"/>'</xsl:comment>
					<constraint firstAttribute="leading" secondAttribute="leading" >
	            	<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
	            	<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="@viewId" />-TV-leading-leading-1</xsl:attribute>
	            </constraint>
	            <constraint firstAttribute="trailing" secondAttribute="trailing">
	            	<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
	            	<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="@viewId" />-TV-trailing-trailing-2</xsl:attribute>
	            </constraint>
	            <constraint firstAttribute="bottom" secondAttribute="bottom" >
	            	<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
	            	<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="@viewId" />-TV-bottom-bottom-3</xsl:attribute>
	            </constraint>
	            <constraint firstAttribute="top" secondAttribute="top">
	            	<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
	            	<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="@viewId" />-TV-top-top-4</xsl:attribute>
	            </constraint>
            </constraints>
		</view>	
		<userDefinedRuntimeAttributes>
			<userDefinedRuntimeAttribute type="string" keyPath="mf.formDescriptorName">
				<xsl:attribute name="value"><xsl:value-of select="formName"/></xsl:attribute>
			</userDefinedRuntimeAttribute>
			<xsl:if test="hasSearchViewController='true'">
				<userDefinedRuntimeAttribute type="boolean" keyPath="mf.search.simpleSearch" value="NO"/>
                <userDefinedRuntimeAttribute type="boolean" keyPath="mf.search.liveSearch" value="NO"/>
                <userDefinedRuntimeAttribute type="boolean" keyPath="mf.search.displayNumberOfResults" value="YES"/>
			</xsl:if>
		</userDefinedRuntimeAttributes>
		<connections>
			<outlet property="tableView">
				<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-OUT-TV</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
			</outlet>
		</connections>
	</viewController>

</xsl:template>


</xsl:stylesheet>