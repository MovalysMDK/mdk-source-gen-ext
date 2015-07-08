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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ex="http://exslt.org/dates-and-times"  extension-element-prefixes="ex">

<xsl:output method="xml"/>

<!-- On utilise la concaténation de la custom Class et du visible Label pour identifier les composants uniques avec ou sans Label. 
Puis pour ne faire apparaître que les composants particuliers au contrôleur générés, on utilise également la concaténation
de l'id du contrôleur et du nom de u 4-ème parent supérieur (on vérifiera que c'est un contrôleur et non un "connection" comme
cela peut-être le cas dans le Worksspace -->
<xsl:key name="subViewCustomClass" match="subView" use="concat(customClass, @visibleLabel, ../../../../@id, localization, name(../../../../.))"/>

<xsl:template match="controller[@controllerType='FORMVIEW' or @controllerType='FIXEDLISTVIEW' or @controllerType='SEARCHVIEW']" >
	
	<xsl:comment>
		#############################
		Controller type = '<xsl:value-of select="@controllerType"/>' - <xsl:value-of select="@type"/>
		Controller ID =  '<xsl:value-of select="@id"/>'
		View ID =  '<xsl:value-of select="@viewId"/>'
		Generation time = <xsl:value-of  select="ex:date-time()"/>
		#############################		
	</xsl:comment>
	
	<!-- position in input XML: 'controller' node -->
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
			<subviews>
			
				<xsl:choose>
					<xsl:when test="(formType = 'TABLE') or (formType = 'MIXTE')">
						<!-- Only 1 subview when controllerType = FORMVIEW or FIXEDLISTVIEW  -->
						<tableView opaque="NO" clipsSubviews="YES" clearsContextBeforeDrawing="NO" contentMode="TopLeft" alwaysBounceVertical="YES" dataMode="prototypes" style="grouped" separatorStyle="default" allowsSelection="NO" rowHeight="44" sectionHeaderHeight="10" sectionFooterHeight="10" translatesAutoresizingMaskIntoConstraints="NO">
							<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
							<xsl:if test="(formType = 'TABLE')">
								<rect key="frame" x="0.0" y="0.0" width="600" height="600"/>
							</xsl:if>
							<xsl:if test="(formType = 'MIXTE')">
								<rect key="frame" x="0.0" width="320">
									<xsl:attribute name="y"><xsl:value-of select="./sections/section[@isNoTable='false'][1]/@framePosY"/></xsl:attribute>
									<xsl:attribute name="height">100</xsl:attribute>
								</rect>
							</xsl:if>
							<color key="backgroundColor" cocoaTouchSystemColor="groupTableViewBackgroundColor"/>
							<constraints>
		                          <!-- constraint firstAttribute="width" priority="1" constant="320" >
			    	   					 <xsl:attribute name="multiplier">1</xsl:attribute>
		                   		 		<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-TV-width-constant-1</xsl:attribute>
		                          </constraint -->
				                  <constraint firstAttribute="width" relation="greaterThanOrEqual" constant="320" >
		                   		 		<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-TV-width-greaterThanOrEqual</xsl:attribute>
			    	  					<xsl:attribute name="multiplier">1</xsl:attribute>
		                          </constraint>
		                    </constraints>		
							<prototypes>
								<!-- Apply template with mode 'gen-table-cell'  on the first 'subView' node of each 'customClass' found with a given visibleLabel value => each category of subview needs to be declared only once in the storyboard file-->
								<xsl:apply-templates select="./sections/section/subViews/subView[(localization='DEFAULT' or localization='DETAIL') and (generate-id(.) = generate-id(key('subViewCustomClass',concat(customClass, @visibleLabel, ../../../../@id, localization, 'controller'))[1]))]" mode="gen-table-cell">
									<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
									<xsl:with-param name="viewId"><xsl:value-of select="@viewId"/></xsl:with-param>
									<xsl:with-param name="posY"><xsl:value-of select="46"/></xsl:with-param>
									<!-- **** => see  ./cells/cell-xxxx.xsl *** -->		
								</xsl:apply-templates>
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
						<xsl:if test="formType='MIXTE'">
							<xsl:apply-templates select="./sections/section[@isNoTable='true']/subViews/subView[(localization='DEFAULT' or localization='DETAIL')]" mode="subview-generation">
								<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
								<!-- **** => see  ./cells/cell-xxxx.xsl *** -->		
							</xsl:apply-templates>
						</xsl:if>
					</xsl:when>
					<xsl:when test="(formType = 'NO_TABLE')">
						<xsl:apply-templates select="./sections/section[@isNoTable='true']/subViews/subView[(localization='DEFAULT' or localization='DETAIL')]" mode="subview-generation">
							<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
							<!-- **** => see  ./cells/cell-xxxx.xsl *** -->		
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="@controllerType='SEARCHVIEW'">
				<navigationBar contentMode="scaleToFill">
				<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-NB</xsl:attribute>
                <rect key="frame" x="0.0" y="0.0" width="320" height="96"/>
                <autoresizingMask key="autoresizingMask" widthSizable="YES" flexibleMaxY="YES"/>
                <items>
                    <navigationItem title="Title">
                    	<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-NB-T</xsl:attribute>
                        <barButtonItem key="leftBarButtonItem" title="Item">
                        <xsl:attribute name="id"><xsl:value-of select="@viewId"/>-NB-LB</xsl:attribute>
                        </barButtonItem>
                        <barButtonItem key="rightBarButtonItem" title="Item">
                        <xsl:attribute name="id"><xsl:value-of select="@viewId"/>-NB-RB</xsl:attribute>
                        </barButtonItem>
                    </navigationItem>
               </items>
               </navigationBar>
               </xsl:if>
			</subviews>
			<color key="backgroundColor" white="1" alpha="1" colorSpace="custom" customColorSpace="calibratedWhite"/>
			<constraints>
				<xsl:choose>
					<xsl:when test="(formType = 'TABLE') or (formType = 'MIXTE')">
						<xsl:apply-templates select="." mode="generate-constraints-table">
							<xsl:with-param name="viewId"><xsl:value-of select="@viewId"/></xsl:with-param>
						</xsl:apply-templates>
						<xsl:apply-templates select="./sections/section[@isNoTable='true']/subViews/subView[(localization='DEFAULT' or localization='DETAIL')]" mode="constraints-generation">
								<xsl:with-param name="cellMargin"><xsl:value-of select="../../@cellMargin"/></xsl:with-param>
								<xsl:with-param name="containerId"><xsl:value-of select="@viewId"/></xsl:with-param> 
								<xsl:with-param name="filterNodeName">localization</xsl:with-param>
								<xsl:with-param name="filterNodeValue">DEFAULT</xsl:with-param>						
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="(formType = 'NO_TABLE')">
						<xsl:apply-templates select="./sections/section/subViews/subView[(localization='DEFAULT' or localization='DETAIL')]" mode="constraints-generation">
								<xsl:with-param name="cellMargin"><xsl:value-of select="../../@cellMargin"/></xsl:with-param>
								<xsl:with-param name="containerId"><xsl:value-of select="@viewId"/></xsl:with-param> 
								<xsl:with-param name="filterNodeName">localization</xsl:with-param>
								<xsl:with-param name="filterNodeValue">DEFAULT</xsl:with-param>						
						</xsl:apply-templates>
						<xsl:apply-templates select="." mode="generate-constraints-noTable">
							<xsl:with-param name="viewId"><xsl:value-of select="@viewId"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
            </constraints>
		</view>
		<xsl:if test="((formType = 'NO_TABLE') or (formType = 'MIXTE'))">
			<extendedEdge key="edgesForExtendedLayout"/>
		</xsl:if>
		<userDefinedRuntimeAttributes>
			<xsl:if test="isInCommentScreen = 'true'">
				<userDefinedRuntimeAttribute type="string" keyPath="mf.commentHTMLFileName">
					<xsl:attribute name="value"><xsl:value-of select="formName"/></xsl:attribute>
				</userDefinedRuntimeAttribute>
			</xsl:if>
		</userDefinedRuntimeAttributes>
		<connections>
			<xsl:if test="@controllerType='SEARCHVIEW'">
			<outlet property="navigationBar">
				<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-OUT-NB</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@viewId"/>-NB</xsl:attribute>
			</outlet>
			<outlet property="navigationBarLeftButton">
				<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-OUT-NB-LB</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@viewId"/>-NB-LB</xsl:attribute>
			</outlet>
			<outlet property="navigationBarRightButton">
				<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-OUT-NB-RB</xsl:attribute>
				<xsl:attribute name="destination"><xsl:value-of select="@viewId"/>-NB-RB</xsl:attribute>
			</outlet>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="(formType = 'TABLE') or (formType = 'MIXTE')">
					<outlet property="tableView">
						<xsl:attribute name="id"><xsl:value-of select="@viewId"/>-OUT-TV</xsl:attribute>
						<xsl:attribute name="destination"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
					</outlet>
					<xsl:apply-templates select="./sections/section[@isNoTable='true']/subViews/subView[(localization='DEFAULT' or localization='DETAIL')]" mode="generate-outlets-noTable">
						<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="(formType = 'NO_TABLE')">
					<xsl:apply-templates select="./sections/section/subViews/subView[(localization='DEFAULT' or localization='DETAIL')]" mode="generate-outlets-noTable">
						<xsl:with-param name="controllerId"><xsl:value-of select="@id"/></xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>
		</connections>
	</viewController>

</xsl:template>

<xsl:template match="subView" mode="generate-outlets-noTable" >
	<xsl:param name="controllerId"/>
	<outlet>
		<xsl:attribute name="id"><xsl:value-of select="@id"/>-OUT-L</xsl:attribute>
		<xsl:attribute name="property"><xsl:value-of select="propertyName"/>_label_<xsl:value-of select="../../@name"/></xsl:attribute>
		<xsl:attribute name="destination"><xsl:value-of select="@labelView"/></xsl:attribute>
	</outlet>
	<outlet>
		<xsl:attribute name="id"><xsl:value-of select="@id"/>-OUT</xsl:attribute>
		<xsl:attribute name="property"><xsl:value-of select="propertyName"/>_<xsl:value-of select="../../@name"/></xsl:attribute>
		<xsl:attribute name="destination"><xsl:value-of select="@id"/></xsl:attribute>
	</outlet>
</xsl:template>


<!--  FORM CONSTRAINTS GENERATION -->

<xsl:template match="controller[@controllerType='FORMVIEW' or @controllerType='FIXEDLISTVIEW']" mode="generate-constraints-noTable" >
	<xsl:attribute name="viewId"><xsl:value-of select="@viewId"/></xsl:attribute>
</xsl:template>

<xsl:template match="controller[@controllerType='FORMVIEW' or @controllerType='FIXEDLISTVIEW']" mode="generate-constraints-table" >
	<xsl:attribute name="viewId"><xsl:value-of select="@viewId"/></xsl:attribute>
	<constraint firstAttribute="bottom"  secondAttribute="bottom" >
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@viewId" />-bottom-bottom-1</xsl:attribute>
	</constraint>
	<constraint firstAttribute="trailing"  secondAttribute="trailing">
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@viewId" />-trailing-trailing-2</xsl:attribute>
	</constraint>
	<constraint firstAttribute="top"  >
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@viewId" />-top-top-3</xsl:attribute>
        <xsl:if test="./formType = 'MIXTE'">
        	<xsl:attribute name="secondAttribute">bottom</xsl:attribute>
        	<xsl:attribute name="secondItem"><xsl:value-of select="./sections/section[@isNoTable='true'][last()]/subViews/subView[last()]/@id"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="./formType = 'TABLE'">
        	<xsl:attribute name="secondAttribute">top</xsl:attribute>
        	<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
        </xsl:if>
	</constraint>
	<constraint firstAttribute="leading"  secondAttribute="leading">
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@viewId" />-leading-leading-4</xsl:attribute>
	</constraint>
	<constraint firstAttribute="centerX"  secondAttribute="centerX">
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@viewId" />-centerX-centerX-5</xsl:attribute>
	</constraint>
</xsl:template>



<xsl:template match="controller[@controllerType='SEARCHVIEW']" mode="generate-constraints-noTable" >
	<xsl:attribute name="viewId"><xsl:value-of select="@viewId"/></xsl:attribute>
</xsl:template>



<xsl:template match="controller[@controllerType='SEARCHVIEW']" mode="generate-constraints-table" >
	<xsl:attribute name="viewId"><xsl:value-of select="@viewId"/></xsl:attribute>

	<constraint firstAttribute="leading"  secondAttribute="leading">
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/>-NB</xsl:attribute>
                 <xsl:attribute name="id"><xsl:value-of select="@viewId" />-leading-leading-TV-NB</xsl:attribute>
	</constraint>
	<constraint firstAttribute="bottom"  secondAttribute="bottom" >
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
                 <xsl:attribute name="id"><xsl:value-of select="@viewId" />-bottom-bottom-TV</xsl:attribute>
	</constraint>
	<constraint firstAttribute="leading"  secondAttribute="leading">
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
                 <xsl:attribute name="id"><xsl:value-of select="@viewId" />-leading-leading-TV</xsl:attribute>
	</constraint>
	<constraint firstAttribute="trailing"  secondAttribute="trailing">
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/>-NB</xsl:attribute>
                 <xsl:attribute name="id"><xsl:value-of select="@viewId" />-trailing-trailing-TV-NB</xsl:attribute>
	</constraint>
	<constraint firstAttribute="trailing"  secondAttribute="trailing">
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/>-NB</xsl:attribute>
                 <xsl:attribute name="id"><xsl:value-of select="@viewId" />-trailing-trailing-NB</xsl:attribute>
	</constraint>
	<constraint firstAttribute="top"  secondAttribute="top" constant="20">
  	  		<xsl:attribute name="multiplier">1</xsl:attribute>
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-NB</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/></xsl:attribute>
                 <xsl:attribute name="id"><xsl:value-of select="@viewId" />-top-top-NB</xsl:attribute>
	</constraint>
	<constraint firstAttribute="top"  secondAttribute="bottom">
		<xsl:attribute name="firstItem"><xsl:value-of select="@viewId"/>-TV</xsl:attribute>
		<xsl:attribute name="secondItem"><xsl:value-of select="@viewId"/>-NB</xsl:attribute>
                 <xsl:attribute name="id"><xsl:value-of select="@viewId" />-top-bottom-TV-NB</xsl:attribute>
	</constraint>
</xsl:template>


</xsl:stylesheet>
