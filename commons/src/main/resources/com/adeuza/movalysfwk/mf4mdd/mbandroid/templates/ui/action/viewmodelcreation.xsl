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

	<xsl:output method="text" />
	
	<!-- Viewmodel with a transient entity -->
	<xsl:template match="action[class/transient='true']" mode="generate-viewmodel-creation">
		<xsl:value-of select="class/implements/interface/@name"/> o<xsl:value-of select="class/implements/interface/@name"/>
		<xsl:text> = Application.getInstance().getTranscientObjectFromCache("", </xsl:text>
		<xsl:value-of select="class/implements/interface/@name"/>.class);
		if (o<xsl:value-of select="class/implements/interface/@name"/> == null) {
			o<xsl:value-of select="class/implements/interface/@name"/> = BeanLoader.getInstance().getBean(<xsl:value-of select="class/pojo-factory-interface/name"/>.class).createInstance();
			Application.getInstance().addTranscientObjectToCache("", <xsl:value-of select="class/implements/interface/@name"/>.class, o<xsl:value-of select="class/implements/interface/@name"/>);
		}
		<xsl:apply-templates select="external-daos/dao-interface" mode="generate-dao-declaration"/>
		<xsl:if test="external-daos">
			try {
		</xsl:if>
				<xsl:value-of select="./viewmodel/implements/interface/@name"/>
						<xsl:text> oVm = oCreator.create</xsl:text><xsl:value-of select="./viewmodel/implements/interface/@name"/>(
						o<xsl:value-of select="class/implements/interface/@name"/>
						<xsl:apply-templates select="external-daos/dao-interface" mode="generate-dao-getX"/>);

				oVm.setEditable(this.isViewModelEnabled(oVm));
		<xsl:if test="external-daos">
			}
			catch(DaoException e) {
				p_oContext.getMessages().addMessage(ExtFwkErrors.ActionError);
			}
		</xsl:if>
		r_sId = o<xsl:value-of select="class/implements/interface/@name"/>.idToString();
	</xsl:template>


	<!-- Viewmodel with a dao -->
	<xsl:template match="action[dao-interface]" mode="generate-viewmodel-creation">
		<xsl:apply-templates select="dao-interface" mode="generate-dao-declaration"/>
		<xsl:apply-templates select="external-daos/dao-interface" mode="generate-dao-declaration"/>

		try {	
			<xsl:variable name="daoVarName">o<xsl:value-of select="dao-interface/dao/interface/name"/></xsl:variable>
		
			<xsl:value-of select="dao-interface/dao/interface/name"/><xsl:text> </xsl:text>
			<xsl:value-of select="$daoVarName"/>
			<xsl:text> = </xsl:text><xsl:apply-templates select="dao-interface" mode="generate-dao-getX"/>;
				
			oCreator.create<xsl:value-of select="./viewmodel/implements/interface/@name"/>
			<xsl:text>(</xsl:text><xsl:value-of select="$daoVarName"/>
			<xsl:apply-templates select="external-daos/dao-interface" mode="generate-dao-getX"/>);

			r_sId = o<xsl:value-of select="dao-interface/dao/interface/name"/>.idToString();
		}
		catch( DaoException oDaoException) {
			p_oContext.getMessages().addMessage(ExtFwkErrors.ActionError);
		}
	</xsl:template>
	
	
	<!-- Viewmodel without entity -->
	<xsl:template match="action[not(class) and not(dao-interface)]" mode="generate-viewmodel-creation">
		<!-- for navigation screen, no viewmodel creation -->
	</xsl:template>
	
</xsl:stylesheet>