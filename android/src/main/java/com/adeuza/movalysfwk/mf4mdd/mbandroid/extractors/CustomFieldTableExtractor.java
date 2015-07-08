/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.mbandroid.extractors;

import java.util.ArrayList;
import java.util.List;

import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.schema.Field;
import com.a2a.adjava.schema.ForeignKey;
import com.a2a.adjava.schema.Index;
import com.a2a.adjava.schema.Schema;
import com.a2a.adjava.schema.SchemaFactory;
import com.a2a.adjava.schema.Table;
import com.a2a.adjava.types.ITypeDescription;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele2schema.SchemaConfig;
import com.a2a.adjava.xmodele2schema.SchemaConfigFactory;

/**
 * <p>TODO Décrire la classe CustomFieldTableExtractor</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public class CustomFieldTableExtractor extends AbstractExtractor<XDomain<ModelDictionary,XModeleFactory>> {
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(CustomFieldTableExtractor.class);

	/**
	 * Configuration du schema
	 */
	protected SchemaConfig schemaConfig = new SchemaConfig();

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.uml2xmodele.extractors.MExtractor#initialize()
	 */
	@Override
	public void initialize(Element p_xConfig) throws Exception {
		SchemaConfigFactory.loadConfiguration(p_xConfig, schemaConfig);
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.uml2xmodele.extractors.MExtractor#extract(com.a2a.adjava.uml.UmlModel)
	 */
	@Override
	public void extract(UmlModel p_oUmlModele) throws Exception {
		final Schema oSchema = this.getDomain().getSchema();
		final SchemaFactory oFactory = this.schemaConfig.getSchemaFactory();
		final CustomFieldDBNamingStrategyImpl oNamingStrategy = (CustomFieldDBNamingStrategyImpl) this.schemaConfig.getDbNamingStrategyClass();

		final ITypeDescription oBooleanType		= this.getDomain().getDictionnary().getTypeDescription("boolean");
		final ITypeDescription oLongType		= this.getDomain().getDictionnary().getTypeDescription("long");
		final ITypeDescription oStringType		= this.getDomain().getDictionnary().getTypeDescription("String");
		final ITypeDescription oTimestampType	= this.getDomain().getDictionnary().getTypeDescription("Timestamp");

		Table oFieldTable = null;
		Table oValueTable = null;
		Field oPKField = null;
		List<Field> listFKFields = null;
		String sTableName = null;
		String sPKName = null;
		for (MEntityImpl oEntity : this.getDomain().getDictionnary().getAllEntities()) {
			if (oEntity.isCustomizable()) {
				oNamingStrategy.setFieldOptions();
				sTableName = oNamingStrategy.getTableName(oEntity.getUmlName());
				sPKName = oNamingStrategy.getPKNameFromTableName(sTableName);

				this.getDomain().getDictionnary().getDaoItfByEntityItf(oEntity.getMasterInterface().getFullName())
						.addParameter("custom_field_table", sTableName);

				oFieldTable = oFactory.createTable(sTableName, sPKName, false);
				oPKField = this.createPKField();
				oPKField.setSequence(oFactory.createSequence(this.schemaConfig.getDbNamingStrategyClass().getSequenceName(sTableName, "id"), "999999999999999"));
				oFieldTable.addField(oPKField);
				oFieldTable.getPrimaryKey().addField(oPKField);
				oFieldTable.addField(oFactory.createField("fieldName", oStringType.getSqlType(), true, new MAttribute("fieldName", "private", true, false, false, oStringType, "_L255", true)));
				oFieldTable.addField(oFactory.createField("idRef", oStringType.getSqlType(), true, new MAttribute("idRef", "private", true, false, false, oStringType, "_L255", true)));
				oSchema.addTable(oFieldTable);

				oNamingStrategy.setValueOptions();
				sTableName = oNamingStrategy.getTableName(oEntity.getUmlName());
				sPKName = oNamingStrategy.getPKNameFromTableName(sTableName);

				this.getDomain().getDictionnary().getDaoItfByEntityItf(oEntity.getMasterInterface().getFullName())
						.addParameter("custom_value_table", sTableName);

				
				oValueTable = oFactory.createTable(sTableName, sPKName, false);
				oPKField = this.createPKField();
				oPKField.setSequence(oFactory.createSequence(this.schemaConfig.getDbNamingStrategyClass().getSequenceName(sTableName, "id"), "999999999999999"));
				oValueTable.getPrimaryKey().addField(oPKField);
				oValueTable.addField(oPKField);
				oValueTable.addField(oFactory.createField("key1", oStringType.getSqlType(), true, new MAttribute("key1", "private", true, false, false, oStringType, "_L255", true)));
				oValueTable.addField(oFactory.createField("key2", oStringType.getSqlType(), true, new MAttribute("key2", "private", true, false, false, oStringType, "_L255", true)));
				oValueTable.addField(oFactory.createField("key3", oStringType.getSqlType(), true, new MAttribute("key3", "private", true, false, false, oStringType, "_L255", true)));
				oValueTable.addField(oFactory.createField("position", oLongType.getSqlType(), true, new MAttribute("position", "private", true, false, false, oLongType, null, true)));
				oValueTable.addField(oFactory.createField("modification", oTimestampType.getSqlType(), true, new MAttribute("modification", "private", true, false, false, oTimestampType, null, true)));
				oValueTable.addField(oFactory.createField("active", oBooleanType.getSqlType(), true, new MAttribute("active", "private", true, false, false, oTimestampType, null, true)));
				oValueTable.addField(oFactory.createField("resourceId", oLongType.getSqlType(), true, new MAttribute("resourceId", null, true, false, false, oLongType, null, true)));
				oValueTable.addField(oFactory.createField("value", oStringType.getSqlType(), true, new MAttribute("value", "private", true, false, false, oStringType, "_L255", true)));

				listFKFields = new ArrayList<Field>();
				for (Field oField : oFieldTable.getPrimaryKey().getFields()) {
					String sFieldName = oNamingStrategy.getFKColumnName("field", oField);
					String sSqlType = oField.getType();
					Field oFkField = oFactory.createField(sFieldName, sSqlType, true, false, null, oField);
					listFKFields.add(oFkField);
					oValueTable.addField(oFkField);
				}

				String sFkName = oNamingStrategy.getFKName("field", oFieldTable);
				ForeignKey oForeignKey = oFactory.createForeignKey(sFkName, listFKFields, oFieldTable.getPrimaryKey().getFields(), oFieldTable,
						false, null);

				oValueTable.addForeignKey(oForeignKey);

				// Creation de l'index
				String sIndexName = oNamingStrategy.getIndexName(oValueTable, "field");
				Index oIndex = oFactory.createIndex(sIndexName, listFKFields, false);
				oValueTable.addIndex(oIndex);

				oSchema.addTable(oValueTable);
			}
		}
	}

	protected Field createPKField() {
		ITypeDescription oLongType = this.getDomain().getDictionnary().getTypeDescription("long");

		Field r_oPKField = this.schemaConfig.getSchemaFactory().createField("id", oLongType.getSqlType(), true, new MAttribute("id", "private", true, false, false, oLongType, null, true));
		return r_oPKField;
	}
}
