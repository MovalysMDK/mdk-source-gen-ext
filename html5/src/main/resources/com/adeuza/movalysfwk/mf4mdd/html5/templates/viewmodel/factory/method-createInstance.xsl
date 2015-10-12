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

	<xsl:output method="text"/>	

	<xsl:template match="*" mode="create-instance">
	
		<xsl:variable name="viewModelVar"><xsl:text>o</xsl:text><xsl:value-of select="name"/></xsl:variable>
	
		<xsl:text>&#10;/**&#10;</xsl:text>
		<xsl:text> * Create an instance of the view model factory&#10;</xsl:text>
		<xsl:text> */&#10;</xsl:text>
	  	<xsl:value-of select="nameFactory"/><xsl:text>.prototype.createInstance = function() {&#10;</xsl:text>
      	<xsl:text>var </xsl:text><xsl:value-of select="$viewModelVar"/>
      	<xsl:text> = new </xsl:text><xsl:value-of select="name"/><xsl:text>();&#10;</xsl:text>
        
        <xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">create-instance</xsl:with-param>
				<xsl:with-param name="defaultSource">

					<xsl:apply-templates select="." mode="create-instance-attributes"/>

					<!--       //initialize subviewmodels (ex: for fixedlist) -->
					<xsl:if test="is-screen-viewmodel='false'">
						<xsl:apply-templates select="subvm/viewmodel" mode="create-instance-init-property">
							<xsl:with-param name="viewModelParent"><xsl:value-of select="$viewModelVar"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:if>
				</xsl:with-param>
		</xsl:call-template>			
		
					<!--       // initialize external viewmodels (combolist) -->
					<xsl:apply-templates select="mapping/entity" mode="create-instance-init-property"/>


      
      	<xsl:text>return </xsl:text><xsl:value-of select="$viewModelVar"/><xsl:text>;&#10;</xsl:text>
      	<xsl:text>};&#10;</xsl:text>
	</xsl:template>
	
	<!-- 		//TODO : Factoriser ce create instance avec celui des entity! -->
	<xsl:template match="*" mode="create-instance-attributes">
		<xsl:variable name="result">o<xsl:value-of select="name"/></xsl:variable>
			<!-- // IDENTIFIER ATTRIBUTES -->
			<xsl:for-each select="./identifier/attribute">
				<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@unsaved-value"/><xsl:text>;&#10;</xsl:text>
			</xsl:for-each>
			
			<!-- // ATTRIBUTES -->
			<xsl:for-each select="./attribute[@transient ='false']">
				<xsl:choose>
					<!--  if NOT enum -->
					<xsl:when test="not(@enum) or @enum = 'false' and not(@type-name='MFPositionViewModel' or @type-name='MFPhotoViewModel')">
						<!-- 	default case -->
						<xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
						<xsl:for-each select="../mapping/attribute[@vm-attr=$name]">
								<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="$name"/><xsl:text> = </xsl:text><xsl:value-of select="@initial-value"/><xsl:text>;&#10;</xsl:text>
						</xsl:for-each>					
					</xsl:when>
					<xsl:when test="@type-name='MFPositionViewModel'">
						<!-- 	MFAddressLocation-->
						<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text> = MFAddressLocationVMFactory.createInstance();&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="@type-name='MFPhotoViewModel'">
						<!-- 	MFPhoto-->
						<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text> = MFPhotoVMFactory.createInstance();&#10;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!--  if enum -->
						<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text>
						<xsl:choose>
							<xsl:when test="contains(@type-name,'enumimage')"><xsl:text>MFValueImageVMFactory.createInstance('key',MFPictureTypeEnum.png,'assets/pictures');&#10;</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>MFRadioVMFactory.createInstance('value');&#10;</xsl:text></xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
						<xsl:when test ="contains(@init, '_NONE')">
							<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>.selectedItem = null ;&#10;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>.selectedItem = </xsl:text><xsl:value-of select="@init"/><xsl:text>;&#10;</xsl:text>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="contains(@type-name,'enumimage')"><xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>.itemsList = </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>.toItemsList();&#10;</xsl:text></xsl:when>
							<xsl:otherwise><xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text>.itemsList = </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text>Converter.toItemsList();&#10;</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			<!-- // ASSOCIATIONS -->
			<xsl:for-each select="./association[(@type='one-to-many' or @type='many-to-many') and @opposite-navigable='true']">
				<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text> = [];&#10;</xsl:text>
			</xsl:for-each>
			
			<xsl:for-each select="./association[(@type='many-to-one' or (@type='one-to-one' and @transient='false')) and @opposite-navigable='true']">	
					<xsl:value-of select="$result"/><xsl:text>.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="pojo-factory-interface/name"/><xsl:text>.createInstance();&#10;</xsl:text>
			</xsl:for-each>
	</xsl:template>

	<xsl:template match="*" mode="create-instance-specific-cases">
	</xsl:template>
	
	<!--       // initialize subviewmodel for fixed list -->
	<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="create-instance-init-property">
		<xsl:param name="viewModelParent"/>
		
		<xsl:text>&#10;</xsl:text>
		<xsl:value-of select="$viewModelParent"/><xsl:text>.lst</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text> = [];&#10;</xsl:text>
	</xsl:template>
	
	<!--       // initialize subviewmodel for list 1D/2D/3D -->
	<xsl:template match="viewmodel[type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3']" mode="create-instance-init-property">
		<xsl:param name="viewModelParent"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:value-of select="$viewModelParent"/><xsl:text>.list = [];&#10;</xsl:text>
	</xsl:template>
	
	<!--       // initialize combolist -->	
	<xsl:template match="entity[@mapping-type='vm_comboitemselected']" mode="create-instance-init-property">
		
		<xsl:variable name="vm-type" select="@vm-type"/>
		<xsl:variable name="matchingExternalList" select="../../external-lists/external-list/viewmodel[name=$vm-type]"/>
		<xsl:variable name="matchingExternalListId" select="$matchingExternalList/identifier/attribute/@name"/>
	
		<xsl:text>&#10;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:text>create-instance-combo-</xsl:text><xsl:value-of select="@vm-attr"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>o</xsl:text><xsl:value-of select="../../name"/><xsl:text>.</xsl:text><xsl:value-of select="@vm-attr"/>
				<xsl:text> = MFComboVMFactory.createInstance('</xsl:text><xsl:value-of select="$matchingExternalListId"/><xsl:text>');&#10;</xsl:text>
				<xsl:text>o</xsl:text><xsl:value-of select="../../name"/><xsl:text>.</xsl:text><xsl:value-of select="@vm-attr"/>
				<xsl:text>.itemsList = this.singleton</xsl:text><xsl:value-of select="@vm-type"/><xsl:text>;&#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="*" mode="create-instance-init-property">
	</xsl:template>

</xsl:stylesheet>