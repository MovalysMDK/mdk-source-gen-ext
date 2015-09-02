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
	
	<xsl:template match="node()" mode="mapping">

		<xsl:if test="count(mapping/attribute) > 0 or count(external-lists/external-list) > 0">
			<xsl:text>&#10;&#10;/**&#10;</xsl:text>
			<xsl:text> * Mapping of all of this view model attributes &#10;</xsl:text>
			<xsl:text> */&#10;</xsl:text>
			<xsl:value-of select="nameFactory"/><xsl:text>.mapping =  {&#10;</xsl:text>
	        <xsl:text>leftFactory:'</xsl:text><xsl:value-of select="entity-to-update/factory-name"/><xsl:text>', rightFactory :'</xsl:text><xsl:value-of select="nameFactory"/><xsl:text>',&#10;</xsl:text>
	        <xsl:text>attributes : [&#10;</xsl:text>
	       
			<!--         For each simple attributes -->
			<xsl:for-each select="mapping/attribute|mapping/entity[@mapping-type='vm_comboitemselected' or count(attribute)>0 or count(entity)>0]">
				<xsl:apply-templates select="." mode="define-mapping-attributes"/>
				<xsl:if test="position() != last()"><xsl:text>,&#10;</xsl:text></xsl:if>
			</xsl:for-each>
				        
	        <xsl:text>]&#10;</xsl:text>
	        <xsl:text>};&#10;</xsl:text>
		</xsl:if>
		
	</xsl:template>



	<xsl:template match="*" mode="define-mapping-attributes" priority="-999">
		<xsl:comment>XSL ERROR: this template should never be applied!!! </xsl:comment>
	</xsl:template>
	
		
	<!-- 	This template is recursive.  -->
	<!-- If the entity child is an attribute, we generate its mapping and the recursivity ends -->
	<!-- If the entity child is an entity, there will be another level of recusivity. we write down the needed information into the variable and dive deeper into the recursive path -->
	<xsl:template match="entity[count(attribute)>0 or count(entity)>0]" mode="define-mapping-attributes">
		<xsl:param name="left-factory"/>
		<xsl:param name="left-attr-path"/>

		<xsl:apply-templates select="./attribute|./entity" mode="define-mapping-attributes">
			<xsl:with-param name="left-factory">
				<xsl:if test="$left-factory"><xsl:value-of select="$left-factory"/>, </xsl:if>		
				<xsl:text>'</xsl:text><xsl:value-of select="setter/@factory"/><xsl:text>'</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="left-attr-path">
				<xsl:value-of select="$left-attr-path"/><xsl:text>'</xsl:text><xsl:value-of select="getter/@name"/><xsl:text>', </xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>
	
	
	<!-- 	Breakpoint of the recursvity : when we arrive at an attribute -->
	<xsl:template match="attribute[not(@initial-value='MFAddressLocationFactory.createInstance()' or @initial-value='MFPhotoFactory.createInstance()')]" mode="define-mapping-attributes">
		<xsl:param name="left-factory"/>
		<xsl:param name="left-attr-path"/>
	
		<xsl:text>&#10;{&#10;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:text>mapping-attribute-</xsl:text><xsl:value-of select="@vm-attr"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
			
				<xsl:text>leftAttr: </xsl:text>
				<xsl:choose>
					<xsl:when test="$left-attr-path">
						<xsl:text>[</xsl:text><xsl:value-of select="$left-attr-path"/><xsl:text>'</xsl:text><xsl:value-of select="getter/@name"/><xsl:text>']</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>'</xsl:text><xsl:value-of select="getter/@name"/><xsl:text>'</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
        		<xsl:text>,&#10;</xsl:text>

	    		<xsl:choose>
		    		<xsl:when test="@vm-attr=../../attribute[@enum='true']/@name">
		    			<xsl:variable name="vm-attr" select="@vm-attr"/>
		    			<xsl:variable name="matchingAttribute" select="../../attribute[@name=$vm-attr]"/>		
						<xsl:variable name="right-enum-factory">
							<xsl:choose>
								<xsl:when test="contains($matchingAttribute/@type-name,'enumimage')" >MFValueImageVMFactory</xsl:when>
								<xsl:otherwise>MFRadioVMFactory</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
		    			<xsl:text>rightAttr:['</xsl:text><xsl:value-of select="@vm-attr"/><xsl:text>','selectedItem'],&#10;</xsl:text>
		    			<xsl:text>rightFactory:'</xsl:text><xsl:value-of select="$right-enum-factory"/><xsl:text>'</xsl:text>
		    			<xsl:if test="not(contains($matchingAttribute/@type-name,'enumimage'))" >
		    				<xsl:text>,&#10;</xsl:text>
		    				<xsl:text>right2leftConverter: ['</xsl:text><xsl:value-of select="$matchingAttribute/@type-short-name"/><xsl:text>Converter', 'enumFromDisplayed'],&#10;</xsl:text>
		    				<xsl:text>left2rightConverter: ['</xsl:text><xsl:value-of select="$matchingAttribute/@type-short-name"/><xsl:text>Converter', 'displayedFromEnum']&#10;</xsl:text>
						</xsl:if>
						<xsl:text>&#10;</xsl:text>
		    		</xsl:when>
		    		<xsl:otherwise>
		    			<xsl:text>rightAttr:'</xsl:text><xsl:value-of select="@vm-attr"/><xsl:text>'</xsl:text>
		    		</xsl:otherwise>
	    		</xsl:choose>
	    		
	    		<xsl:if test="not(vm-attr-initial-value)">
	    			<xsl:text>, identifier: true&#10;</xsl:text>
        		</xsl:if>
        		 
        		<xsl:if test="$left-factory">
        			<xsl:text>, childIdentifier:true,&#10;</xsl:text>
	        		<xsl:text>leftFactory: [</xsl:text><xsl:value-of select="$left-factory"/><xsl:text>]&#10;</xsl:text>
        		</xsl:if>
        		
				<!--         		test signature -->				
        		<xsl:if test="@vm-attr=../../attribute[@type-name='MFSignature']/@name">
					<xsl:text>, right2leftConverter: ['MFJsonConverter','jsonToString']</xsl:text>
					<xsl:text>, left2rightConverter: ['MFJsonConverter','fromString']</xsl:text>
        		</xsl:if>

	    	</xsl:with-param>
	    </xsl:call-template>
	    <xsl:text>&#10;}</xsl:text>
	    <xsl:if test="position() != last()"><xsl:text>,&#10;</xsl:text></xsl:if>
	</xsl:template>

	<!-- 		Special case photo -->
	<xsl:template match="attribute[@initial-value='MFPhotoFactory.createInstance()']" mode="define-mapping-attributes">
		<xsl:param name="left-factory"/>
		<xsl:param name="left-attr-path"/>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">name</xsl:with-param>
				<xsl:with-param name="right-attr">name</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFPhoto</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">uri</xsl:with-param>
				<xsl:with-param name="right-attr">uri</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFPhoto</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">date</xsl:with-param>
				<xsl:with-param name="right-attr">date</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFPhoto</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">desc</xsl:with-param>
				<xsl:with-param name="right-attr">desc</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFPhoto</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">photoState</xsl:with-param>
				<xsl:with-param name="right-attr">photoState','selectedItem</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFPhoto</xsl:with-param>
				<xsl:with-param name="specific-right-factory">['MFPhotoVMFactory','MFComboVMFactory']</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">photoLocation</xsl:with-param>
				<xsl:with-param name="right-attr">photoLocation</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFPhoto</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>

			
	</xsl:template>



	<!-- 		Special case addresslocation -->
	<xsl:template match="attribute[@initial-value='MFAddressLocationFactory.createInstance()']" mode="define-mapping-attributes">
		<xsl:param name="left-factory"/>
		<xsl:param name="left-attr-path"/>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">latitude</xsl:with-param>
				<xsl:with-param name="right-attr">latitude</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFAddressLocation</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">longitude</xsl:with-param>
				<xsl:with-param name="right-attr">longitude</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFAddressLocation</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">compl</xsl:with-param>
				<xsl:with-param name="right-attr">compl</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFAddressLocation</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">street</xsl:with-param>
				<xsl:with-param name="right-attr">street</xsl:with-param>	
				<xsl:with-param name="specific-component-name">MFAddressLocation</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">city</xsl:with-param>
				<xsl:with-param name="right-attr">city</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFAddressLocation</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
			<xsl:text>,&#10;</xsl:text>
			
			<xsl:apply-templates select="." mode="define-mapping-attribute-specific-component">
				<xsl:with-param name="left-attr">country</xsl:with-param>
				<xsl:with-param name="right-attr">country</xsl:with-param>
				<xsl:with-param name="specific-component-name">MFAddressLocation</xsl:with-param>
				<xsl:with-param name="left-attr-path"><xsl:value-of select="$left-attr-path"/></xsl:with-param>
			</xsl:apply-templates>
	    <xsl:if test="position() != last()"><xsl:text>,&#10;</xsl:text></xsl:if>			
	</xsl:template>
	
	
	
	<xsl:template match="attribute" mode="define-mapping-attribute-specific-component">
		<xsl:param name="left-attr"/>
		<xsl:param name="right-attr"/>
		<xsl:param name="left-attr-path"/>
		<xsl:param name="specific-component-name"/>
		<xsl:param name="specific-right-factory"/>
		  <xsl:text>&#10;{&#10;</xsl:text>
		  <xsl:text>leftAttr: [</xsl:text><xsl:value-of select="$left-attr-path"/><xsl:text>'</xsl:text><xsl:value-of select="getter/@name"/><xsl:text>','</xsl:text><xsl:value-of select="$left-attr"/><xsl:text>'],&#10;</xsl:text>
          <xsl:text>rightAttr: ['</xsl:text><xsl:value-of select="@vm-attr"/><xsl:text>','</xsl:text><xsl:value-of select="$right-attr"/><xsl:text>'],</xsl:text>
		  <xsl:text>leftFactory:'</xsl:text><xsl:value-of select="$specific-component-name"/><xsl:text>Factory',&#10;</xsl:text>
		  <xsl:text>rightFactory:</xsl:text>	
		  <xsl:choose>
		  	<xsl:when test="$specific-right-factory">
		  		<xsl:value-of select="$specific-right-factory"/><xsl:text>&#10;</xsl:text>
		  	</xsl:when>
		  	<xsl:otherwise>
		  		<xsl:text>'</xsl:text><xsl:value-of select="$specific-component-name"/><xsl:text>VMFactory'&#10;</xsl:text>
		  	</xsl:otherwise>
		  </xsl:choose>
          <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="." mode="define-mapping-attribute-specific-component" priority="-999">
		<xsl:comment>XSL ERROR: this template should never be applied!!! </xsl:comment>	
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="define-mapping-attributes" priority="-999">
		<xsl:comment>XSL ERROR: this template should never be applied!!! </xsl:comment>
	</xsl:template>
	
	
	<!-- 	mapping for combo  -->
		<xsl:template match="entity[@mapping-type='vm_comboitemselected']" mode="define-mapping-attributes">
	
		<xsl:variable name="vm-type" select="@vm-type"/>
		<xsl:variable name="matchingExternalList" select="../../external-lists/external-list/viewmodel[name=$vm-type]"/>
		<xsl:variable name="matchingExternalListId" select="$matchingExternalList/identifier/attribute/@name"/>
		
		<xsl:variable name="left-attr-id">
				<xsl:value-of select="$matchingExternalList/mapping/attribute[@vm-attr=$matchingExternalListId]/getter/@name"/>
		</xsl:variable>

		<xsl:text>&#10;{&#10;</xsl:text>
	 	<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId"><xsl:text>mapping-combo-attribute-</xsl:text><xsl:value-of select="@vm-attr"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
			
	 			<xsl:text>leftAttr: ['</xsl:text><xsl:value-of select="getter/@name"/><xsl:text>','</xsl:text><xsl:value-of select="$left-attr-id"/>
	 			<xsl:text>'], rightAttr:['</xsl:text><xsl:value-of select="@vm-attr"/><xsl:text>','selectedItemValue'], childIdentifier: true, leftFactory:'</xsl:text><xsl:value-of select="setter/@factory"/>
	 			<xsl:text>', rightFactory:'MFComboVMFactory',right2leftConverter:['MFIntegerConverter','fromString'] &#10;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#10;}</xsl:text>
	</xsl:template>
</xsl:stylesheet>