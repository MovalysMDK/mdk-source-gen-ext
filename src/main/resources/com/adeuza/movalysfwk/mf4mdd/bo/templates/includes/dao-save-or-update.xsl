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

<xsl:template name="dao-save-or-update-interface">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>
	/**
	 * Sauve ou met à jour l'entité <xsl:value-of select="$interface/name"/> passée en paramètre selon son existence en base.
	 *
	 * La cascade est CascadeSet.NONE
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdate<xsl:value-of select="$interface/name"/>( <xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>
			<xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
	
	/**
	 * Sauve ou met à jour l'entité <xsl:value-of select="$interface/name"/> passée en paramètre selon son existence en base.
	 *
	 * @param p_o<xsl:value-of select="$interface/name"/> une entité <xsl:value-of select="$interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdate<xsl:value-of select="$interface/name"/>( <xsl:value-of select="$interface/name"/> p_o<xsl:value-of select="$interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>

<xsl:template name="dao-save-or-update">
	/**
	 * Sauve ou met à jour l'entité <xsl:value-of select="interface/name"/> passée en paramètre selon son existence en base.
	 *
	 * La cascade est CascadeSet.NONE
	 *
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/>
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdate<xsl:value-of select="interface/name"/>( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, ItfTransactionalContext p_oContext ) throws DaoException {
		this.saveOrUpdate</xsl:text><xsl:value-of select="interface/name"/><xsl:text>(p_o</xsl:text><xsl:value-of select="interface/name"/>, CascadeSet.NONE, p_oContext);
	}

	/**
	 * Sauve ou met à jour l'entité <xsl:value-of select="interface/name"/> passée en paramètre selon son existence en base.
	 *
	 * @param p_o<xsl:value-of select="interface/name"/> une entité <xsl:value-of select="interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oContext contexte transactionnel
	 *
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdate<xsl:value-of select="interface/name"/>( <xsl:value-of select="interface/name"/> p_o<xsl:value-of select="interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, ItfTransactionalContext p_oContext ) throws DaoException {
		</xsl:text>

		this.validateBean(p_o<xsl:value-of select="interface/name"/>,p_oContext);
		boolean bHaveErrorMessage = p_oContext.getMessages().hasErrors();
		
		if (!bHaveErrorMessage) {
			<xsl:if test="count(class/identifier/attribute/field/sequence) = 1">
			if(p_o<xsl:value-of select="interface/name"/><xsl:text>.</xsl:text>
				<xsl:value-of select="class/identifier/attribute/get-accessor"/>() <xsl:text><![CDATA[< 0]]></xsl:text>) {
				
				if ( !p_o<xsl:value-of select="interface/name"/>.getReferences().isEmpty() <xsl:text><![CDATA[&&]]></xsl:text> !bHaveErrorMessage) {
					<xsl:call-template name="dao-reference-loadbyreference-beforesave"/>
				}
				if (p_o<xsl:value-of select="interface/name"/>.getId() <xsl:text><![CDATA[<]]></xsl:text> 0) {
					this.save<xsl:value-of select="interface/name"/>(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext);
				} else {
					this.update<xsl:value-of select="interface/name"/>(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext);
				}
			} else {
				this.update<xsl:value-of select="interface/name"/>(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext);
			}
			</xsl:if>
			
			<xsl:if test="count(class/identifier/attribute/field/sequence) = 0">
				if(this.exist(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext)) {
					this.update<xsl:value-of select="interface/name"/>(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext);
				} else {
					this.save<xsl:value-of select="interface/name"/>(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext);
				}
			</xsl:if>
			
			<xsl:if test="count(class/identifier/attribute/field/sequence) > 1">
				<xsl:variable name="stest">
					<xsl:for-each select="class/identifier/attribute/field/sequence">
						p_o<xsl:value-of select="../../../../../interface/name"/>.<xsl:value-of select="../../get-accessor"/>() <xsl:text><![CDATA[< 0]]></xsl:text>
						<xsl:if test="position() != last()"><xsl:text>||</xsl:text></xsl:if></xsl:for-each>
				</xsl:variable>
				if(<xsl:value-of select="$stest"/>) {
					this.save<xsl:value-of select="interface/name"/>(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext);
				} else {
					this.update<xsl:value-of select="interface/name"/>(p_o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext);
				}
			</xsl:if>
			
			<xsl:if test="count(class/identifier/descendant::attribute) = 1">
			/*DISABLED IN BACKPORT
			if (!p_oCascadeSet.contains(CascadeSet.GenericCascade.NOT_ALL_DYN) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !p_oCascadeSet.contains(<xsl:value-of select="interface/name"/>.Cascade.NOT_DYN) <xsl:text><![CDATA[&&]]></xsl:text> !bHaveErrorMessage) {
				this.dynamicalFieldDao.saveOrUpdateDynamicalFieldsForEntity(<xsl:value-of select="interface/name"/>.ENTITY_NAME.toLowerCase(), p_o<xsl:value-of select="interface/name"/>, p_oContext);
			}
			*/
			</xsl:if>
		}
	}
</xsl:template>

</xsl:stylesheet>
