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

	<xsl:key name="dataloader-combo-getter" match="entity-getter-name" use="../entity"/>

	<xsl:template match="viewmodel" mode="generate-method-update-from-dataloader">
		/**
		 * Updates the viewmodel using a <xsl:value-of select="dataloader-impl/implements/interface/@name"/>.
		 * @param p_oDataloader
		 * 			The dataloader.
		 */
		@Override
		public void updateFromDataloader(final Dataloader&lt;?&gt; p_oDataloader) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">updateFromDataLoader-method</xsl:with-param>
				<xsl:with-param name="defaultSource">final ViewModelCreator oVMCreator = (ViewModelCreator) BeanLoader.getInstance().getBean(ExtBeanType.ViewModelCreator);
					if (p_oDataloader == null) {
						this.updateFromIdentifiable(null);
					} else if (<xsl:value-of select="dataloader-impl/implements/interface/@name"/>.class.isAssignableFrom(p_oDataloader.getClass())) {
					final <xsl:value-of select="dataloader-impl/implements/interface/@name"/> oDataloader = (<xsl:value-of select="dataloader-impl/implements/interface/@name"/>
					<xsl:text>) p_oDataloader;&#13;</xsl:text>
					<xsl:apply-templates select="." mode="generate-body-update-from-dataloader"/>
					<xsl:text>}&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>

	<xsl:template match="viewmodel[type/name='MASTER']" mode="generate-body-update-from-dataloader">
		<xsl:if test="count(./data-path/path)>0">
			<xsl:text>if (oDataloader.getData(this.getKey())!=null</xsl:text>
			<xsl:for-each select="./data-path/path">
				<xsl:text> &amp;&amp; oDataloader.getData(this.getKey())</xsl:text><xsl:value-of select="full-path"/><xsl:text>!=null</xsl:text>
			</xsl:for-each>
			<xsl:text>) {</xsl:text>
			
			<xsl:text>oVMCreator.createOrUpdate</xsl:text>
			<xsl:value-of select="implements/interface/@name"/>
			<xsl:text>(oDataloader.getData(this.getKey())</xsl:text><xsl:value-of select="./data-path/full-path"/>
			<xsl:apply-templates select=".//external-list/viewmodel" mode="generate-method-update-from-dataloader"/>
			
			<xsl:text>);&#13;} else {</xsl:text>
			
			<xsl:value-of select="entity-to-update/name"/> 
			<xsl:text> data = BeanLoader.getInstance().getBean(</xsl:text>
			<xsl:value-of select="entity-to-update/factory-name"/>.class).createInstance();
			<xsl:text>oVMCreator.createOrUpdate</xsl:text>
			<xsl:value-of select="implements/interface/@name"/>
			<xsl:text>(data</xsl:text>
			<xsl:apply-templates select=".//external-list/viewmodel" mode="generate-method-update-from-dataloader"/>
			<xsl:text>);&#13;}</xsl:text>
		</xsl:if>
		<xsl:if test="count(./data-path/path)=0">
			<xsl:value-of select="entity-to-update/name"/> data = oDataloader.getData(this.getKey());
			if ( data == null ) {
				data = BeanLoader.getInstance().getBean(<xsl:value-of select="entity-to-update/factory-name"/>.class).createInstance();
			}
			
			<xsl:if test="not(dataloader-impl/dataloader-interface/type='WORKSPACE')">
				Set&lt;DataLoaderParts&gt; reload = oDataloader.popReload(this.getKey());
			</xsl:if>
			
			<xsl:variable name="DataLoaderItf" ><xsl:value-of select="dataloader-impl/implements/interface/@name"/></xsl:variable>
			
			<xsl:if test="count(external-lists/external-list) > 0 or (count(subvm/viewmodel/external-lists/external-list) > 0) and subvm/viewmodel[type/name='FIXED_LIST']">
				<xsl:apply-templates select="." mode="create-updateing-info">
					<xsl:with-param name="dataloader" select="$DataLoaderItf"/>
				</xsl:apply-templates>
			</xsl:if>
			
			<xsl:text>oVMCreator.createOrUpdate</xsl:text>
			<xsl:value-of select="implements/interface/@name"/>
			<xsl:text>(</xsl:text>
			<xsl:if test="multiInstance='true'">
				<xsl:text>this.getKey(), </xsl:text>
			</xsl:if>
			<xsl:text>data, </xsl:text>
			
			<xsl:choose> 
				<xsl:when test="dataloader-impl/dataloader-interface/type='WORKSPACE'">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>reload.contains(</xsl:text><xsl:value-of select="dataloader-impl/implements/interface/@name"/><xsl:text>.DataLoaderPartEnum.DATA)</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="(count(external-lists/external-list)>0) or ((count(subvm/viewmodel/external-lists/external-list) > 0) and subvm/viewmodel[type/name='FIXED_LIST'])">
				<xsl:text>, oInfo</xsl:text>
			</xsl:if>
			<xsl:text>);&#13;</xsl:text>
<!-- 			<xsl:apply-templates select=".//external-list/viewmodel" mode="generate-method-update-from-dataloader"/> -->
<!-- 			<xsl:text>);&#13;</xsl:text> -->
		</xsl:if>
	</xsl:template>

	<xsl:template match="viewmodel[type/name='LIST_1' or type/name='LIST_2' or type/name='LIST_3']" mode="generate-body-update-from-dataloader">
		<xsl:text>this.clear();&#13;</xsl:text>
		<xsl:text>oVMCreator.createOrUpdate</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>(oDataloader.getData(this.getKey()));&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="external-list/viewmodel" mode="generate-method-update-from-dataloader">
		<xsl:text>, oDataloader.getList</xsl:text>
		<xsl:value-of select="uml-name-u"/>
<!-- 		<xsl:value-of select="key('dataloader-combo-getter', entity-to-update/name)"/> -->
		<xsl:text>()</xsl:text>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="create-updateing-info">
		<xsl:param name="dataloader"/>
		
		<xsl:if test ="external-lists/external-list/viewmodel or subvm/viewmodel[type/name='FIXED_LIST']/external-lists/external-list/viewmodel">
			<xsl:text>ViewModelCreator.VO</xsl:text><xsl:value-of select="implements/interface[1]/@name"/>
			<xsl:text> oInfo</xsl:text>
			<xsl:text> = new ViewModelCreator.VO</xsl:text><xsl:value-of select="implements/interface[1]/@name"/><xsl:text>();&#13;</xsl:text>
			
			<xsl:for-each select="external-lists/external-list/viewmodel">
					<!-- set list -->
					<xsl:text>oInfo</xsl:text>
					<xsl:text>.setList</xsl:text>
					<xsl:value-of select="uml-name"/>
					<xsl:text>(</xsl:text>
					<xsl:text>oDataloader.getList</xsl:text>
					<xsl:value-of select="uml-name-u"/>
					<xsl:text>()</xsl:text>
					<xsl:text>);&#13;</xsl:text>
					<!-- set modified boolean -->
					<xsl:text>oInfo</xsl:text>
					<xsl:text>.setList</xsl:text>
					<xsl:value-of select="uml-name"/>
					<xsl:text>Modified(</xsl:text>
					
					<xsl:choose> 
						<xsl:when test="/viewmodel/dataloader-impl/dataloader-interface/type='WORKSPACE'">
							<xsl:text>true</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>reload.contains(</xsl:text>
							<xsl:value-of select="$dataloader"/>
							<xsl:text>.DataLoaderPartEnum.</xsl:text>
							<xsl:value-of select="translate(uml-name-u, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
							<xsl:text>)</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:text>);&#13;</xsl:text>
				</xsl:for-each>
				
				<xsl:for-each select="subvm/viewmodel[type/name='FIXED_LIST']/external-lists/external-list/viewmodel">
					<!-- set list -->
					<xsl:text>oInfo</xsl:text>
					<xsl:text>.setList</xsl:text>
					<xsl:value-of select="uml-name"/>
					<xsl:text>(</xsl:text>
					<xsl:text>oDataloader.getList</xsl:text>
					<xsl:value-of select="uml-name-u"/>
					<xsl:text>()</xsl:text>
					<xsl:text>);&#13;</xsl:text>
					<!-- set modified boolean -->
					<xsl:text>oInfo</xsl:text>
					<xsl:text>.setList</xsl:text>
					<xsl:value-of select="uml-name"/>
					<xsl:text>Modified(</xsl:text>
					<xsl:choose> 
						<xsl:when test="/viewmodel/dataloader-impl/dataloader-interface/type='WORKSPACE'">
							<xsl:text>true</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>reload.contains(</xsl:text>
							<xsl:value-of select="$dataloader"/>
							<xsl:text>.DataLoaderPartEnum.</xsl:text>
							<xsl:value-of select="translate(uml-name-u, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
							<xsl:text>)</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>);&#13;</xsl:text>
				</xsl:for-each>
				
				
		</xsl:if>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
